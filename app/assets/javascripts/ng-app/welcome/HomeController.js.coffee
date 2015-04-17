angular.module('ngApp').controller 'HomeController', [
  '$state', '$gon', 'WechatLoginModal',
  ($state,   $gon,   WechatLoginModal) ->
    vm = @

    vm.currentUser = $gon.currentUser

    vm.start = ->
      unless vm.currentUser
        WechatLoginModal.activateWithUser()
      else
        $state.go('dashboard.books.index')

    return vm
]
