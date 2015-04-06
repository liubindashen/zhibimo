angular.module('ngApp', ['ngAnimate', 'ngMessages', 'ui.router', 'templates', 'restangular', 'ui.codemirror', 'angular-underscore'])
  .config ($stateProvider, $urlRouterProvider, $locationProvider, RestangularProvider) ->
    $stateProvider
      .state('home', {
        url: '/'
        templateUrl: 'welcome/home.html'
        controller: 'HomeController'
      })
      .state('explore', {
        url: '/explore'
        templateUrl: 'explore/default.html'
        controller: 'ExploreController'
      })
      .state('dashboard', {
        abstract: true
        url: '/dashboard'
        templateUrl: 'dashboard/layout.html'
        controller: 'DashboardController'
      })
      .state('dashboard.index', {
        url: '/index'
        templateUrl: 'dashboard/book_list.html'
        controller: 'BookListController'
      })
      .state('dashboard.new', {
        url: '/new'
        templateUrl: 'dashboard/book_new.html'
        controller: 'BookNewController'
      })
      .state('editor', {
        url: '/editor/:bookId'
        templateUrl: 'dashboard/book_editor.html'
        controller: 'BookEditorController'
      })

    $urlRouterProvider.otherwise('/');
    $locationProvider.html5Mode(true);

    RestangularProvider.setRequestSuffix('.json');
