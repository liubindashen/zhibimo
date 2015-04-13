angular.module('ngApp').controller 'DashboardController', [
  '$gon', '$state', ($gon, $state) ->
    unless $gon.currentUser
      $state.go 'home'
]
