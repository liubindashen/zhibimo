angular.module('ngApp').controller 'HomeController', [
  '$state', '$gon', 'WechatLoginModal',
  ($state,   $gon,   WechatLoginModal) ->
    vm = @

    vm.currentUser = $gon.currentUser

    vm.start = ->
      $scope.isLoginVisible = true
      unless vm.currentUser
        WechatLoginModal.activateWithWechat()
      else
        $state.go('dashboard.books.index')

    return vm
]
