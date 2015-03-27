angular.module('myApp')
  .controller 'DashboardController', ($scope, $state, currentUser, bookService) ->
    bookService.all().then (books) ->
      console.log books

    unless currentUser
      $state.go 'home'
