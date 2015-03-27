#= require angular
#= require angular-resource
#= require moment
#= require jquery
#= require jquery_ujs
#= require_self

app = angular.module 'mainApp', []

app.run ($rootScope) ->
  $rootScope.name = 'username'
