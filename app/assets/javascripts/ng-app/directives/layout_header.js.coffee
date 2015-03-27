angular.module('myApp')
  .directive 'layoutHeader', ->
    restrict: 'A'
    templateUrl: 'header.html'
    controller: ($scope, $element, $attrs, $transclude, currentUser) ->
      $scope.active = $attrs['active']
      $scope.currentUser = currentUser
