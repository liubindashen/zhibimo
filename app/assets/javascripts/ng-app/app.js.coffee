angular.module('myApp', ['ngAnimate', 'ui.router', 'templates' ])
  .config ($stateProvider, $urlRouterProvider, $locationProvider) ->
    $stateProvider
      .state('home', {
        url: '/'
        templateUrl: 'home.html'
        controller: 'HomeController'
      })
      .state('dashboard', {
        url: '/dashboard'
        templateUrl: 'dashboard.html'
        controller: 'DashboardController'
      })

    $urlRouterProvider.otherwise('/');
    $locationProvider.html5Mode(true);

