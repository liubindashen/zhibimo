#= require jquery
#= require jquery_ujs
#= require zeroclipboard
#= require semantic-ui/dist/components/transition.min
#= require semantic-ui/dist/components/dropdown.min
#= require semantic-ui/dist/components/dimmer.min
#= require semantic-ui/dist/components/modal.min

jQuery.fn.exists = -> @length > 0

$ ->
  new ZeroClipboard($(".copy.action"))

  if $('#wechat_login_wrapper').exists()
    new WxLogin
      id: 'wechat_login_wrapper'
      appid: gon.wxConfig.appId
      scope: 'snsapi_login'
      redirect_uri: 'http%3A%2F%2Fzhibimo.com%2Fauth%2Fwechat%2Fcallback'
      href: $('#wechat_login_wrapper').data('href')
      state: 'fucking-state'

  $('.ui.dropdown').dropdown()

  $('#view_gitlab_auth_info').click ->
    $('#gitlab_auth_info_modal').modal({blurring: true}).modal('show')
