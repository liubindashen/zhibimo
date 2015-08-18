angular.module('ngApp').factory 'EditorHistoryService', ->
  _undoSize = 0
  _redoSize = 0
  
  canUndo: ->
    _undoSize <= 0

  canRedo: ->
    _redoSize <= 0

  set: (undo, redo) ->
    _undoSize = undo
    _redoSize = redo
