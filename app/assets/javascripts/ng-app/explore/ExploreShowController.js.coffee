angular.module('ngApp').controller 'ExploreShowController', [
  '$stateParams', 'ExploreService',
  ($stateParams,   ExploreService)->
    vm = @

    ExploreService.one($stateParams['id']).get().then (book) ->
      vm.book = book

    return vm
]
