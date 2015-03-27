angular.module('myApp')
  .factory 'bookService', (Restangular) ->
    _bookService = Restangular.all('books')

    all: ->
      _bookService.getList()

    post: (book) ->
      _bookService.post(book)
