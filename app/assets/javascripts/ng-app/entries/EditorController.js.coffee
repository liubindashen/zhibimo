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

    vm.formatHeader = ->
      debugger
      vm.editor.execCommand "goLineStartSmart"
      [word, range] = currentWord()

      if word.match /^#{1,5}$/
        vm.doc.replaceSelection("#")
      else if word.match /^#{6}$/
        selectionRange(range)
        vm.doc.replaceSelection("#")
      else
        vm.doc.replaceSelection("# ")

    currentWord = ->
      c = vm.doc.getCursor()
      r = vm.editor.findWordAt(c)
      [vm.editor.getRange(r.anchor, r.head), r]

    selectionRange = (range) ->
      vm.editor.setSelection(range.anchor, range.head)

    return vm
]
