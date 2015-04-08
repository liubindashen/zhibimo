angular.module('ngApp', ['ngAnimate', 'ngMessages', 'ui.router', 'templates', 'restangular', 'ui.codemirror', 'angular-underscore'])
  .config ($stateProvider, $urlRouterProvider, $locationProvider, RestangularProvider) ->
    $stateProvider
      .state('home', {
        url: '/'
        templateUrl: 'welcome/home.html'
        controller: 'HomeController'
      })
      .state('explore', {
        abstract: true
        url: '/explore'
        templateUrl: 'explore/layout.html'
      })
      .state('explore.index', {
        url: '/'
        templateUrl: 'explore/index.html'
        controller: 'ExploreIndexController'
        controllerAs: 'vm'
      })
      .state('explore.show', {
        url: '/:id'
        templateUrl: 'explore/show.html'
        controller: 'ExploreShowController'
        controllerAs: 'vm'
      })
      .state('dashboard', {
        abstract: true
        url: '/dashboard'
        templateUrl: 'dashboard/layout.html'
        controller: 'DashboardController'
      })
      .state('dashboard.index', {
        url: '/index'
        templateUrl: 'dashboard/index.html'
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

    RestangularProvider.setBaseUrl('api/v1');
    RestangularProvider.setRequestSuffix('.json');
