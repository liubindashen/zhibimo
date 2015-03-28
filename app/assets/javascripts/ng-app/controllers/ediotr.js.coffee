angular.module('myApp')
  .controller 'EditorController', ($scope, $state, $sce, $stateParams, $timeout, currentUser, kramedService, bookService) ->

    bookService.one($stateParams['bookId']).get().then (book) ->
      book.getList('entries').then (entries) ->
        $scope.book = book
        $scope.entries = entries
        $scope.setCurrent($scope.first(entries).id)

    $scope.setCurrent = (entryId) ->
      $scope.saveEntry() if $scope.entry
      $scope.book.one('entries', entryId).get().then (entryWithContent) ->
        $scope.entry = entryWithContent

    $scope.saveEntry = ->
      if $scope.entry.changed
        console.debug "changed #{$scope.entry.path} and save it!"
        $scope.entry.save() 
      
    $scope.isActive = (entryId) ->
      return false unless $scope.entry
      $scope.entry.id == entryId

    $scope.newEntry = ->
      path = prompt("Please Input Entry Name")
      entry = path: path
      $scope.book.all('entries').post(entry).then (entry) ->
        $scope.entries.push entry

    $scope.render = (content) ->
      $sce.trustAsHtml(kramedService.render(content))

    delayInMs = 3000
    timeoutPromise = null

    $scope.entryChange = ->
      $scope.setEntryChanged()
      $timeout.cancel(timeoutPromise)
      changeFun = ->
        $scope.saveEntry()
      timeoutPromise = $timeout changeFun, delayInMs

    $scope.setEntryChanged = ->
      $scope.entry.changed = true
