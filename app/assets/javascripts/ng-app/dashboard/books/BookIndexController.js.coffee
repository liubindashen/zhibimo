angular.module('ngApp').controller 'BookIndexController', [
  'BookService', '$state'
  (BookService,   $state) ->
    vm = @
    vm.books = []

    BookService.getList().then (books) ->
      vm.books = books

    vm.goEditor = (book) ->
      $state.go('editor', {slug: book.slug})

    vm.edit = (book) ->
      $state.go('dashboard.books.edit', {slug: book.slug})

    return vm
]
