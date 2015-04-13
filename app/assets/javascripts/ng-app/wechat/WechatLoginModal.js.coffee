angular.module('ngApp').factory 'WechatLoginModal', [
  'btfModal', '$wx_login', '$gon',
  (btfModal,   $wx_login,   $gon) ->
    modal = btfModal
      templateUrl: 'wechat/login.html'
      controller: 'WechatLoginController'
      controllerAs: 'vm'

    modal.activateWithWechat = ->
      return if modal.isActivate

      modal.isActivate = true
      modal.activate().then ->
        new $wx_login
          id: 'wechat_login_wrapper'
          appid: $gon.wxConfig.appId
          scope: 'snsapi_login'
          redirect_uri: 'http%3A%2F%2Fzhibimo.com%2Fauth%2Fwechat%2Fcallback'
          state: 'fucking-state'

    return modal
]
