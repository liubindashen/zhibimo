app = angular.module('ngApp', ['ngAnimate', 'ngMessages', 'ui.router', 'templates', 'restangular', 'ui.codemirror', 'angular-underscore', 'angularFileUpload', 'ng-rails-csrf', 'wx-login', 'gon', 'btford.modal'])

app.config [
  '$stateProvider', '$urlRouterProvider', '$locationProvider', 'RestangularProvider',
  ($stateProvider,   $urlRouterProvider,   $locationProvider,   RestangularProvider) ->
    $stateProvider
      .state('home', {
        url: '/'
        templateUrl: 'welcome/home.html'
        controller: 'HomeController'
        controllerAs: 'vm'
      })
      # Explore Route
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
        url: '/:slug'
        templateUrl: 'explore/show.html'
        controller: 'ExploreShowController'
        controllerAs: 'vm'
      })
      # Dashboard Route
      .state('dashboard', {
        url: '/dashboard'
        templateUrl: 'dashboard/layout.html'
        controller: 'DashboardController'
        abstract: true
      })
      # Dashboard Books Route
      .state('dashboard.books', {
        url: '/books'
        templateUrl: 'dashboard/books/layout.html'
        abstract: true
      })
      .state('dashboard.books.index', {
        url: '/'
        templateUrl: 'dashboard/books/index.html'
        controller: 'BookIndexController'
        controllerAs: 'vm'
      })
      .state('dashboard.books.new', {
        url: '/new'
        templateUrl: 'dashboard/books/new.html'
        controller: 'BookNewController'
        controllerAs: 'vm'
      })
      .state('dashboard.books.edit', {
        url: '/edit/:slug'
        templateUrl: 'dashboard/books/edit.html'
        controller: 'BookEditController'
        controllerAs: 'vm'
      })
      .state('editor', {
        url: '/editor/:slug'
        templateUrl: 'editor/index.html'
        controller: 'EditorController'
        controllerAs: 'vm'
      })

    $urlRouterProvider.otherwise('/')
    $locationProvider.html5Mode(true)

    RestangularProvider.setBaseUrl('api/v1')
    RestangularProvider.setRequestSuffix('.json')
]

app.run [
  '$rootScope',
  ($rootScope) ->
    $rootScope.$on '$stateChangeSuccess', (event, toState) ->
      $rootScope.currentState = toState
]
