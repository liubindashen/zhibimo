angular.module('ngApp').controller 'EditorController', [
  '$state', '$sce', '$stateParams', '$timeout', '$gon', 'KramedService', 'BookService',
  ($state,   $sce,   $stateParams,   $timeout,  $gon,  KramedService,   BookService) ->
    vm = @

    BookService.one($stateParams['slug']).get().then (book) ->
      book.getList('entries').then (entries) ->
        vm.book = book
        vm.entries = entries
        vm.setCurrent(_.first(entries).id)

    vm.editorOptions = 
      mode: 'markdown'
      lineWrapping : true

    vm.setCurrent = (entryId) ->
      vm.saveEntry() if vm.currentEntry
      vm.book.one('entries', entryId).get().then (entryWithContent) ->
        vm.currentEntry = entryWithContent

    vm.saveEntry = ->
      if vm.currentEntry.changed
        console.debug "changed #{vm.currentEntry.path} and save it!"
        vm.currentEntry.save()
      
    vm.isActive = (entryId) ->
      return false unless vm.currentEntry
      vm.currentEntry.id == entryId

    vm.newEntry = ->
      path = prompt("Please Input Entry Name")
      entry = path: path
      vm.book.all('entries').post(entry).then (entry) ->
        vm.entries.push entry

    vm.render = (content) ->
      html = KramedService.render(content)
      $sce.trustAsHtml(html)

    delayInMs = 3000
    timeoutPromise = null

    vm.entryChange = ->
      vm.setEntryChanged()
      $timeout.cancel(timeoutPromise)
      changeFun = ->
        vm.saveEntry()
      timeoutPromise = $timeout changeFun, delayInMs

    vm.setEntryChanged = ->
      vm.currentEntry.changed = true

    vm.codemirrorLoaded = (editor) ->
      editor.focus()

      vm.editor = editor
      vm.doc = editor.getDoc()
      
    vm.formatHeader = ->
      vm.editor.execCommand "goLineStartSmart"
      [word, range] = vm.currentWord()

      if word.match /^#{1,5}$/
        vm.doc.replaceSelection("#")
      else if word.match /^#{6}$/
        vm.selectionRange(range)
        vm.doc.replaceSelection("#")
      else
        vm.doc.replaceSelection("# ")

    vm.currentWord = ->
      c = vm.doc.getCursor()
      r = vm.editor.findWordAt(c)
      [vm.editor.getRange(r.anchor, r.head), r]


    vm.selectionRange = (range) ->
      vm.editor.setSelection(range.anchor, range.head)


    return vm
]
