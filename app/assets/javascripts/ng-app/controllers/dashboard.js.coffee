angular.module('myApp')
  .controller 'DashboardController', ($scope, $state, currentUser, bookService) ->
    unless currentUser
      $state.go 'home'
