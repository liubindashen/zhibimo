angular.module('ngApp')
  .factory 'ExploreService', (Restangular) ->
    _exploreService = Restangular.service('explore')

    getList: _exploreService.getList
