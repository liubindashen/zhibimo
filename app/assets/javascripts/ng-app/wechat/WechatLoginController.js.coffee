angular.module('ngApp').controller 'WechatLoginController', [
  'WechatLoginModal', '$wx_login', '$gon'
  (WechatLoginModal,   $wx_login,   $gon) ->
    vm = @
    vm.close = WechatLoginModal.deactivateWithUser

    return vm
]
