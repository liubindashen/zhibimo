angular.module('ngApp').controller 'ExploreShowController', [
  '$stateParams', 'ExploreService', '$sce', 'KramedService',
  ($stateParams,   ExploreService,   $sce,   KramedService)->
    vm = @


    vm.render = (content) ->
      $sce.trustAsHtml(KramedService.render(content))

    ExploreService.one($stateParams['slug']).get().then (book) ->
      vm.book = book

    return vm
]
