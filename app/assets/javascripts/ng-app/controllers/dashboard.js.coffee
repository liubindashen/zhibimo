angular.module('myApp')
  .controller 'DashboardController', ($scope, $state, currentUser) ->
    unless currentUser
      $state.go 'home'
