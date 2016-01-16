#= require jquery
#= require jquery_ujs
#= require semantic_ui/semantic_ui

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

  $('.ui.dropdown').dropdown()

  if $('#new_book').exists()
    $('#accept_term_checkbox').checkbox
      onChecked: ->
        $("#new_book [type=submit]").removeClass('disabled')
      onUnchecked: ->
        $("#new_book [type=submit]").addClass('disabled')

    $('#purchase_radio').checkbox
      onChecked: ->
        $('#free_field').hide()
        $('#purchase_field').show()

    $('#free_radio').checkbox
      onChecked: ->
        $('#free_field').show()
        $('#purchase_field').hide()

    if $('#purchase_radio').checkbox('is checked')
      $('#free_field').hide()
      $('#purchase_field').show()
    else
      $('#free_field').show()
      $('#purchase_field').hide()

  $("#editor_sidebar")
    .sidebar('setting', 'dimPage', false)
    .sidebar('setting', 'transition', 'overlay')
    .sidebar('setting', 'closable', false)
    .sidebar('toggle')

  $(".ui.secondary.pointing.content.menu .item").tab()
