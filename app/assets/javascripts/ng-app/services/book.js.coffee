angular.module('myApp')
  .factory 'bookService', (Restangular) ->
    _bookService = Restangular.service('books')

    one: _bookService.one
    post: _bookService.post
    getList: _bookService.getList
