angular.module('ngApp')
  .directive 'header', ->
    restrict: 'A'
    templateUrl: 'layout/header.html'
    controller: ($scope, $element, $attrs, $transclude, currentUser) ->
      $scope.active = $attrs['active']
      $scope.currentUser = currentUser
