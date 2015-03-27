angular.module('myApp')
  .controller 'HomeController', ($scope) ->
    $scope.things = ['A', 'B', 'C']
