angular.module('myApp')
  .controller 'HomeController', ($scope, currentUser) ->
    $scope.currentUser = currentUser
