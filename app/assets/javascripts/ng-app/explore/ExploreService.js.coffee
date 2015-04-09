angular.module('ngApp').factory 'ExploreService', [
  'Restangular', 
  (Restangular) ->
    _exploreService = Restangular.service('explore')

    one: _exploreService.one
    getList: _exploreService.getList
]
