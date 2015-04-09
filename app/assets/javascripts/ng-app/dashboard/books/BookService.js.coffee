angular.module('ngApp').factory 'BookService', [
  'Restangular',
  (Restangular) ->
    _bookService = Restangular.service('books')

    one: _bookService.one
    post: _bookService.post
    getList: _bookService.getList
]
