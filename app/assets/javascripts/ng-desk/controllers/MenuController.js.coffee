angular.module('ngApp').controller 'MenuController', [
  '$rootScope', 'EditorHistoryService'
  ($rootScope,   EditorHistoryService) ->
    vm = @

    vm.command = (command) ->
      $rootScope.$broadcast("cmd-#{command}")

    vm.canUndo = EditorHistoryService.canUndo
    vm.canRedo = EditorHistoryService.canRedo
]
