angular.module('myApp')
  .controller 'ListBookController', ($scope, bookService) ->
    $scope.books = []
    bookService.all().then (books) ->
      console.log books
      $scope.books = books
