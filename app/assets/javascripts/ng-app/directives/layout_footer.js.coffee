angular.module('myApp')
  .directive 'layoutFooter', ->
    restrict: 'A'
    template: "<div class='footer'>© 2015 zhibimo.com All rights reserved.</div>"
