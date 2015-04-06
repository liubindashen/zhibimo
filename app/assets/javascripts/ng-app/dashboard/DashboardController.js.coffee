angular.module('ngApp')
  .controller 'DashboardController', ($scope, $state, currentUser, BookService) ->
    unless currentUser
      $state.go 'home'
