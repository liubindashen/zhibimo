#= require jquery
#= require retinajs/dist/retina

jQuery.fn.exists = -> @length > 0

$ ->
  if $('#wechat_login_wrapper').exists()
    new WxLogin
      id: 'wechat_login_wrapper'
      appid: gon.wxConfig.appId
      scope: 'snsapi_login'
      redirect_uri: 'http%3A%2F%2Fzhibimo.com%2Fauth%2Fwechat%2Fcallback'
      href: $('#wechat_login_wrapper').data('href')
      state: 'fucking-state'
