angular.module('ngApp').controller 'MenuController', [
  '$rootScope',
  ($rootScope) ->
    vm = @

    vm.command = (command) ->
      $rootScope.$broadcast("cmd-#{command}")
]
