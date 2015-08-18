app = angular.module('ngApp', ['ngAnimate', 'ngMessages', 'ui.router', 'templates', 'restangular', 'ui.codemirror', 'angular-underscore', 'angularFileUpload', 'ng-rails-csrf', 'gon'])

app.config [
  '$stateProvider', '$urlRouterProvider', '$locationProvider', 'RestangularProvider',
  ($stateProvider,   $urlRouterProvider,   $locationProvider,   RestangularProvider) ->
    $stateProvider
      .state('desk', {
        url: '/'
        templateUrl: 'index.html'
      })

    $urlRouterProvider.otherwise('/')
    $locationProvider.html5Mode(true)

    RestangularProvider.setBaseUrl('/api/v1')
    RestangularProvider.setRequestSuffix('.json')
    RestangularProvider.setEncodeIds(true)
]
