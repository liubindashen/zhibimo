angular.module('ngApp').controller 'ExploreListController', [
  '$state', 'ExploreService',
  ($state,   ExploreService) ->
    vm = @
    vm.books = []

    vm.view = (book) ->
      console.log book.title
      

    ExploreService.getList().then (books) ->
      vm.books = books
      #debugger

    return vm
]