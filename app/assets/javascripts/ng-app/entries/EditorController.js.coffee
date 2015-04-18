angular.module('ngApp').controller 'EditorController', [
  '$timeout', 'EntriesService',
  ($timeout,   EntriesService) ->
    vm = @

    vm.entry = EntriesService.getCurrentWithDetail

    vm.editorOptions = 
      mode: 'markdown'
      lineWrapping : true

    vm.codemirrorLoaded = (editor) ->
      editor.focus()
      vm.editor = editor
      vm.doc = editor.getDoc()

    delaySaveTimeout = 3000
    timeoutPromise = null

    vm.changed = ->
      console.debug 'check timeout to change'
      $timeout.cancel(timeoutPromise)
      timeoutPromise = $timeout ->
        console.debug 'changed'
        EntriesService.save()
      , delaySaveTimeout

    vm.command = (command) ->
      vm[command]()
      vm.editor.focus()

    vm.formatHeader = ->
      vm.editor.execCommand "goLineStartSmart"
      [word, range] = currentWord()

      if word.match /^#{1,5}$/
        vm.doc.replaceSelection("#")
      else if word.match /^#{6}$/
        selectionRange(range)
        vm.doc.replaceSelection("#")
      else
        vm.doc.replaceSelection("# ")
      
    vm.formatStrong = ->
      selection = selectionOrLine()
      selection = selection.replace(/^(\s*)/, "\$1**")
      selection = selection.replace(/(\s*)$/, "**\$1")
      vm.doc.replaceSelection(selection)

    vm.formatStrikethrough = ->
      selection = selectionOrLine()
      selection = selection.replace(/^(\s*)/, "\$1~~")
      selection = selection.replace(/(\s*)$/, "~~\$1")
      vm.doc.replaceSelection(selection)

    vm.formatItalic = ->
      selection = selectionOrLine()
      selection = selection.replace(/^(\s*)/, "\$1*")
      selection = selection.replace(/(\s*)$/, "*\$1")
      vm.doc.replaceSelection(selection)

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
