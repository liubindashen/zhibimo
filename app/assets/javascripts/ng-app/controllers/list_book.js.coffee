angular.module('myApp')
  .controller 'ListBookController', ($scope, bookService) ->
    $scope.books = []

    bookService.getList().then (books) ->
      console.log books
      $scope.books = books
