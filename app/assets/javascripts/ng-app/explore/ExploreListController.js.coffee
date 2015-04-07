angular.module('ngApp').controller 'ExploreListController', [
  '$state', 'ExploreService',
  ($state,   ExploreService) ->
    vm = @
    vm.books = []

    vm.view = (book) ->
      console.log book.title

    ExploreService.getList().then (books) ->
      vm.booksWithGroup = _.chain(books).groupBy (e, i) ->
        Math.floor(i/3)
      .toArray()
      .value()

    return vm
]
