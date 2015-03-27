angular.module('myApp')
  .directive 'layoutHeader', ->
    restrict: 'A'
    templateUrl: 'header.html'
    controller: ($scope, $element, $attrs, $transclude) ->
      $scope.active = $attrs['active']
