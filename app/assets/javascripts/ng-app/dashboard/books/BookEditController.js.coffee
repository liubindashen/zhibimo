angular.module('ngApp').controller 'BookEditController', [
  '$state', 'BookService', '$stateParams'
  ($state,   BookService,   $stateParams) ->
    vm = @

    BookService.one($stateParams['slug']).get().then (book) ->
      vm.book = book

    return vm
]
