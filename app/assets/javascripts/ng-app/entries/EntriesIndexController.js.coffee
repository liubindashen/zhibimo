angular.module('ngApp').controller 'EntriesIndexController', [
  '$state', '$sce', '$stateParams', '$timeout', '$gon', 'KramedService', 'EntriesService',
  ($state,   $sce,   $stateParams,   $timeout,  $gon,  KramedService,   EntriesService) ->
    vm = @

    [vm.book, vm.entries] = EntriesService.fetch($stateParams['slug'])

    vm.setCurrent = EntriesService.setCurrent
    vm.getCurrent = EntriesService.getCurrent

    vm.newEntry = ->
      path = prompt("Please Input Entry Name")
      EntriesService.create path: path

    return vm
]
