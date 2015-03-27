/*
 *= require jquery
 *= require jquery_ujs
 *= require codemirror-5.1/lib/codemirror
 *= require codemirror-5.1/addon/mode/overlay
 *= require codemirror-5.1/mode/xml/xml
 *= require codemirror-5.1/mode/markdown/markdown
 *= require codemirror-5.1/mode/javascript/javascript
 *= require codemirror-5.1/mode/css/css
 *= require codemirror-5.1/mode/htmlmixed/htmlmixed
 *= require codemirror-5.1/mode/clike/clike
 *= require codemirror-5.1/mode/clike/clike
 *= require codemirror-5.1/mode/meta
 *= require kramed-0.4.6/lib/kramed
 *= require_self
 */

$(document).ready(function() {
  var editor = CodeMirror.fromTextArea($('#editor #textarea')[0], {
    mode: 'gfm',
    lineNumbers: false,
    theme: "default"
  });

  editor.on('changes', function () {
    var content = kramed(editor.getValue());
    $('#editor #preview').html(content);
  });

  var book = $('body').data('book');
  $.get("/books/" + book + "/entries.json", function (data) {
    for (var i in data) {
      var entry = $("<li></li>").html(data[i].path)
      entry.attr("data-entry", data[i].id);
      $('#explorer #entries').append(entry);
    }
  });

  $("#explorer #entries").on('click', 'li', function (e) {
    e.preventDefault();
    $.get("/books/" + book + "/entries/" + $(this).data('entry') + ".json", function (data) {
      editor.setValue(data.content);
    });
  });
});
