angular.module('myApp', ['ngAnimate', 'ngMessages', 'ui.router', 'templates', 'restangular', 'ui.codemirror', 'angular-underscore'])
  .config ($stateProvider, $urlRouterProvider, $locationProvider, RestangularProvider) ->
    $stateProvider
      .state('home', {
        url: '/'
        templateUrl: 'home.html'
        controller: 'HomeController'
      })
      .state('explore', {
        url: '/explore'
        controller: 'ExploreController'
        templateUrl: "explore.html"
      })
      .state('dashboard', {
        abstract: true
        url: '/dashboard'
        controller: 'DashboardController'
        templateUrl: "dashboard/layout.html"
      })
      .state('dashboard.index', {
        url: '/index'
        controller: 'ListBookController'
        templateUrl: "dashboard/index.html"
      })
      .state('dashboard.new', {
        url: '/new'
        controller: 'NewBookController'
        templateUrl: "dashboard/new.html"
      })
      .state('editor', {
        url: '/editor/:bookId'
        controller: 'EditorController'
        templateUrl: "editor.html"
      })

    $urlRouterProvider.otherwise('/');
    $locationProvider.html5Mode(true);

    RestangularProvider.setRequestSuffix('.json');
