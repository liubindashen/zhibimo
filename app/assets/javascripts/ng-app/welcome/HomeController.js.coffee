angular.module('ngApp').controller 'HomeController', [
  '$scope', 'currentUser',
  ($scope, currentUser) ->
    $scope.currentUser = currentUser
]
