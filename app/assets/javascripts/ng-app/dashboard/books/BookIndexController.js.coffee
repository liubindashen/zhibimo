angular.module('ngApp').controller 'BookIndexController', [
  'BookService', '$state'
  (BookService,   $state) ->
    vm = @
    vm.books = []

    BookService.getList().then (books) ->
      vm.books = books

    vm.entries = (book) ->
      $state.go('entries', {slug: book.slug})

    vm.edit = (book) ->
      $state.go('dashboard.books.edit', {slug: book.slug})

    return vm
]
