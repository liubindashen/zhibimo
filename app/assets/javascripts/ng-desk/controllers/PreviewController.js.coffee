angular.module('ngApp').controller 'PreviewController', [
  'KramedService', 'EntriesService', '$sce',
  (KramedService,   EntriesService,   $sce) ->
    vm = @

    vm.entry = EntriesService.getCurrent

    vm.render = ->
      entry = vm.entry()
      return unless entry
      html = KramedService.render(entry.content || '')
      $sce.trustAsHtml(html)

    return vm
]
