angular.module('myApp', ['ngAnimate', 'ui.router', 'templates' ])
  .config ($stateProvider, $urlRouterProvider, $locationProvider) ->
    home = 
      url: '/'
      templateUrl: 'home.html'
      controller: 'HomeController'

    $stateProvider.state 'home', home
    $urlRouterProvider.otherwise('/');
    $locationProvider.html5Mode(true);

