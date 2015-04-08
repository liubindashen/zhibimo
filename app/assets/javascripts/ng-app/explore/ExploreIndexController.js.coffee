angular.module('ngApp').controller 'ExploreIndexController', [
  '$state', 'ExploreService',
  ($state,   ExploreService) ->
    vm = @
    vm.books = []

    vm.view = (book) ->
      $state.go 'explore.show', {slug: book.slug}

    ExploreService.getList().then (books) ->
      vm.booksWithGroup = _.chain(books).groupBy (e, i) ->
        Math.floor(i/5)
      .toArray()
      .value()

    return vm
]
