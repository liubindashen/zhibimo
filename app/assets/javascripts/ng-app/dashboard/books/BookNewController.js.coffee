angular.module('ngApp').controller 'BookNewController', [
  '$state', 'BookService',
  ($state,   BookService) ->
    vm = @

    vm.submit = ->
      BookService.post(vm.book).then (book) ->
        $state.go 'dashboard.books.index'

    return vm
]
