angular.module('ngApp').factory 'BookService', [
  'Restangular', '$gon',
  (Restangular,   $gon) ->
    _bookService = Restangular.service('books')

    current: _bookService.one($gon.book.id)
]
