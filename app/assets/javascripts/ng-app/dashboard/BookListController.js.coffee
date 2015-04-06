angular.module('ngApp')
  .controller 'BookListController', ($scope, BookService) ->
    $scope.books = []

    BookService.getList().then (books) ->
      console.log books
      $scope.books = books
