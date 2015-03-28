angular.module('myApp')
  .controller 'NewBookController', ($scope, $state, bookService) ->
    $scope.submit = ->
      bookService.post($scope.book).then (book) ->
        $state.go 'dashboard.index'
