angular.module('ngApp').controller 'DashboardController', [
  'currentUser', (currentUser) ->
    unless currentUser
      $state.go 'home'
]
