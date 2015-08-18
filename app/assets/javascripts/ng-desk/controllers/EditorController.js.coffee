angular.module('ngApp').controller 'EditorController', [
  '$scope', '$timeout', 'EntriesService',
  ($scope,   $timeout,   EntriesService) ->
    vm = @

    vm.entry = EntriesService.getCurrent

    vm.editorOptions = 
      mode: 'markdown'
      lineWrapping : true

    vm.codemirrorLoaded = (editor) ->
      editor.focus()
      vm.editor = editor
      vm.doc = editor.getDoc()

    delaySaveTimeout = 1500
    timeoutPromise = null

    vm.changed = ->
      EntriesService.editing()
      console.debug 'check timeout to change'
      $timeout.cancel(timeoutPromise)
      timeoutPromise = $timeout ->
        console.debug 'changed'
        EntriesService.save()
      , delaySaveTimeout


    vm.on = (name, callback) ->
      $scope.$on "cmd-#{name}", ->
        callback()
        vm.editor.focus()

    vm.on 'header', ->
      vm.editor.execCommand "goLineStartSmart"
      [word, range] = currentWord()

      if word.match /^#{1,3}$/
        vm.doc.replaceSelection("#")
      else if word.match /^#{4}$/
        selectionRange(range)
        vm.doc.replaceSelection("#")
      else
        vm.doc.replaceSelection("# ")
      
    vm.on 'strong', ->
      selection = selectionOrLine()
      selection = selection.replace(/^(\s*)/, "\$1**")
      selection = selection.replace(/(\s*)$/, "**\$1")
      vm.doc.replaceSelection(selection)

    vm.on 'strikethrough', ->
      selection = selectionOrLine()
      selection = selection.replace(/^(\s*)/, "\$1~~")
      selection = selection.replace(/(\s*)$/, "~~\$1")
      vm.doc.replaceSelection(selection)

    vm.on 'italic', ->
      selection = selectionOrLine()
      selection = selection.replace(/^(\s*)/, "\$1*")
      selection = selection.replace(/(\s*)$/, "*\$1")
      vm.doc.replaceSelection(selection)

    vm.on 'list', ->
      return unless vm.doc.somethingSelected()
      selection = vm.doc.getSelection()
      selection = vm.selection.replace(/\n/g, "\n- ").replace(/^/, "- ")
      vm.doc.replaceSelection(selection)

    vm.on 'ordered-list', ->
      return unless vm.doc.somethingSelected()
      selection = vm.doc.getSelection()
      selection = vm.selection.replace(/\n/g, "\n1. ").replace(/^/, "1. ")
      vm.doc.replaceSelection(selection)

    vm.on 'linkify', ->
      return unless vm.doc.somethingSelected()
      selection = vm.doc.getSelection()
      vm.doc.replaceSelection("[#{selection}]()")
      vm.editor.execCommand "goCharLeft"

    vm.on 'quote', ->
      selection = selectionOrLine()
      selection = selection.replace(/\n/g, "\n> ").replace(/^/, "> ")
      vm.doc.replaceSelection(selection)

    vm.on 'code', ->
      selection = selectionOrLine()
      vm.doc.replaceSelection("```\n#{selection}\n```")

    currentWord = ->
      c = vm.doc.getCursor()
      r = vm.editor.findWordAt(c)
      [vm.editor.getRange(r.anchor, r.head), r]

    selectionOrLine = ->
      unless vm.doc.somethingSelected()
        vm.editor.execCommand "goLineStartSmart"
        start = vm.doc.getCursor()
        vm.editor.execCommand "goLineEnd"
        end = vm.doc.getCursor()
        selectionRange(anchor: end, head: start)
      vm.doc.getSelection()

    selectionRange = (range) ->
      vm.editor.setSelection(range.anchor, range.head)

    return vm
]
