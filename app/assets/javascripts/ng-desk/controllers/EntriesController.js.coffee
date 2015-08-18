angular.module('ngApp').controller 'EntriesController', [
  '$scope', '$state', '$sce', '$stateParams', '$timeout', '$gon', 'KramedService', 'EntriesService',
  ($scope,   $state,   $sce,   $stateParams,   $timeout,  $gon,  KramedService,   EntriesService) ->
    vm = @

    $scope.$on 'cmd-new', ->
      path = prompt("请输入文件名称：")
      EntriesService.create path: path

    $scope.$on 'cmd-save', ->
      unless vm.getPushing()
        EntriesService.push() 
        alert("图书的所有更改均已提交到版本库中，后台正在进行构建，请稍后查看。")

    vm.entries = EntriesService.fetch()

    vm.setCurrent = EntriesService.setCurrent
    vm.getCurrent = EntriesService.getCurrent
    vm.getPushing = EntriesService.getPushing

    return vm
]
