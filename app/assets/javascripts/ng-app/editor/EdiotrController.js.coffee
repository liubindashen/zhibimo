angular.module('ngApp').controller 'EditorController', [
  '$state', '$sce', '$stateParams', '$timeout', '$gon', 'KramedService', 'BookService',
  ($state,   $sce,   $stateParams,   $timeout,  $gon,  KramedService,   BookService) ->
    vm = @

    BookService.one($stateParams['slug']).get().then (book) ->
      book.getList('entries').then (entries) ->
        vm.book = book
        vm.entries = entries
        vm.setCurrent(_.first(entries).id)

    vm.editorOptions = 
      lineWrapping : true

    vm.setCurrent = (entryId) ->
      vm.saveEntry() if vm.currentEntry
      vm.book.one('entries', entryId).get().then (entryWithContent) ->
        vm.currentEntry = entryWithContent

    vm.saveEntry = ->
      if vm.currentEntry.changed
        console.debug "changed #{vm.currentEntry.path} and save it!"
        vm.currentEntry.save()
      
    vm.isActive = (entryId) ->
      return false unless vm.currentEntry
      vm.currentEntry.id == entryId

    vm.newEntry = ->
      path = prompt("Please Input Entry Name")
      entry = path: path
      vm.book.all('entries').post(entry).then (entry) ->
        vm.entries.push entry

    vm.render = (content) ->
      $sce.trustAsHtml(KramedService.render(content))

    delayInMs = 3000
    timeoutPromise = null

    vm.entryChange = ->
      vm.setEntryChanged()
      $timeout.cancel(timeoutPromise)
      changeFun = ->
        vm.saveEntry()
      timeoutPromise = $timeout changeFun, delayInMs

    vm.setEntryChanged = ->
      vm.currentEntry.changed = true

    return vm
]
