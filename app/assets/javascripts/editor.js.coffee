#= require jquery
#= require jquery_ujs
#= require semantic-ui/dist/components/sidebar.min
#= require semantic-ui/dist/components/sticky.min
#= require codemirror/lib/codemirror
#= require codemirror/mode/markdown/markdown
#= require codemirror/addon/scroll/scrollpastend
#= require kramed/kramed.min

$ ->
  editor = CodeMirror($('#editor')[0], {
    mode: "markdown"
    lineWrapping : true
    scrollbarStyle: 'simple'
  })

  editor.focus()
  doc = editor.getDoc()

  editor.on 'change', ->
    newPreview = "<div id='preview'>#{kramed(editor.getValue())}</div>"
    $('#preview').replaceWith(newPreview)

  currentWord = ->
    c = doc.getCursor()
    r = editor.findWordAt(c)
    [editor.getRange(r.anchor, r.head), r]

  selectionOrLine = ->
    unless doc.somethingSelected()
      editor.execCommand "goLineStartSmart"
      start = doc.getCursor()
      editor.execCommand "goLineEnd"
      end = doc.getCursor()
      selectionRange(anchor: end, head: start)
    doc.getSelection()

  selectionRange = (range) ->
    editor.setSelection(range.anchor, range.head)

  $('#btnFormatHeader').click ->
    editor.execCommand "goLineStartSmart"
    [word, range] = currentWord()

    if word.match /^#{1,3}$/
      doc.replaceSelection("#")
    else if word.match /^#{4}$/
      selectionRange(range)
      doc.replaceSelection("#")
    else
      doc.replaceSelection("# ")

  $('#btnFormatStrong').click ->
    selection = selectionOrLine()
    selection = selection.replace(/^(\s*)/, "\$1**")
    selection = selection.replace(/(\s*)$/, "**\$1")
    doc.replaceSelection(selection)

  $('#btnFormatStrikethrough').click ->
    selection = selectionOrLine()
    selection = selection.replace(/^(\s*)/, "\$1~~")
    selection = selection.replace(/(\s*)$/, "~~\$1")
    doc.replaceSelection(selection)

  $('#btnFormatItalic').click ->
    selection = selectionOrLine()
    selection = selection.replace(/^(\s*)/, "\$1*")
    selection = selection.replace(/(\s*)$/, "*\$1")
    doc.replaceSelection(selection)

  $('#btnFormatList').click ->
    return unless doc.somethingSelected()
    selection = doc.getSelection()
    selection = selection.replace(/\n/g, "\n- ").replace(/^/, "- ")
    doc.replaceSelection(selection)

  $('#btnFormatOrderedList').click ->
    return unless doc.somethingSelected()
    selection = doc.getSelection()
    selection = selection.replace(/\n/g, "\n1. ").replace(/^/, "1. ")
    doc.replaceSelection(selection)

  $('#btnFormatLink').click ->
    return unless doc.somethingSelected()
    selection = doc.getSelection()
    doc.replaceSelection("[#{selection}]()")
    editor.focus()
    editor.execCommand "goCharLeft"

  $('#btnFormatQuote').click ->
    selection = selectionOrLine()
    selection = selection.replace(/\n/g, "\n> ").replace(/^/, "> ")
    doc.replaceSelection(selection)

  $('#btnFormatCode').click ->
    selection = selectionOrLine()
    doc.replaceSelection("```\n#{selection}\n```")
