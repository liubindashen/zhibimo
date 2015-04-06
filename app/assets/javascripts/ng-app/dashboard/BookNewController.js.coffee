angular.module('ngApp')
  .controller 'BookNewController', ($scope, $state, BookService) ->
    $scope.submit = ->
      BookService.post($scope.book).then (book) ->
        $state.go 'dashboard.index'
