angular.module('myApp', ['ngAnimate', 'ui.router', 'templates' ])
  .config ($stateProvider, $urlRouterProvider, $locationProvider) ->
    $stateProvider
      .state('home', {
        url: '/'
        templateUrl: 'home.html'
        controller: 'HomeController'
      })
      .state('dashboard', {
        abstract: true
        url: '/dashboard'
        controller: 'DashboardController'
        templateUrl: "dashboard/layout.html"
      })
      .state('dashboard.index', {
        url: '/index'
        templateUrl: "dashboard/index.html"
      })

    $urlRouterProvider.otherwise('/');
    $locationProvider.html5Mode(true);

