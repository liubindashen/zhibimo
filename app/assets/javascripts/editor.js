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
  var book = $('body').data('book');
  var editor = CodeMirror.fromTextArea($('#editor #textarea')[0], {
    mode: 'gfm',
    lineNumbers: false,
    theme: "default",
    autofocus: true,
    lineWrapping: true,
  });

  editor.on('changes', function () {
    var content = kramed(editor.getValue());
    $('#editor #preview').html(content);
  });

  $("#explorer #entries").on('click', 'li', function (e) {
    e.preventDefault();
    if (editor.entry !== undefined) {
      $.ajax({
        type: 'PATCH',
        url: '/books/' + book + '/entries/' + editor.entry + ".json",
        data: { content: editor.getValue() },
        success: function (data) { }
      });
    }
    var entry = $(this).data('entry');
    $('#entries li').removeClass('active-entry');
    $(this).addClass('active-entry');
    $.get("/books/" + book + "/entries/" + entry + ".json", function (data) {
      editor.setValue(data.content);
      editor.entry = entry;
      editor.focus();
    });
  });

  function appendEntry(data) {
    var entry = $("<li></li>").html(data.path)
    entry.attr("data-entry", data.id);
    $('#explorer #entries').append(entry);
  }

  $.get("/books/" + book + "/entries.json", function (data) {
    for (var i in data) {
      appendEntry(data[i]);
    }
    $("#explorer #entries li:first-child").trigger('click');
  });

  $('#new-entry-button').on('click', function () {
    var path = prompt("请输入文件名");
    if (path === null || path === undefined || $.trim(path).length === 0) {
      return;
    }

    $.post("/books/" + book + "/entries.json", { path: path }, function (data) {
      appendEntry(data);
    });
  });
});
