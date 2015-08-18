angular.module('ngApp').controller 'EntriesController', [
  '$state', '$sce', '$stateParams', '$timeout', '$gon', 'KramedService', 'EntriesService',
  ($state,   $sce,   $stateParams,   $timeout,  $gon,  KramedService,   EntriesService) ->
    vm = @

    vm.entries = EntriesService.fetch()

    vm.setCurrent = EntriesService.setCurrent
    vm.getCurrent = EntriesService.getCurrent
    vm.getPushing = EntriesService.getPushing

    vm.touch = ->
      path = prompt("请输入文件名称：")
      EntriesService.create path: path

    vm.push = ->
      unless vm.getPushing()
        EntriesService.push() 
        alert("图书的所有更改均已提交到版本库中，后台正在进行构建，请稍后查看。")

    return vm
]
