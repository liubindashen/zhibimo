angular.module('myApp')
  .controller 'NewBookController', ($scope, $state, bookService) ->
    @book = {}

    $scope.submit = ->
      bookService.post(@book).then (book) ->
        console.log book
        $state.go 'dashboard.index'

