angular.module('ngApp').factory 'EntriesService', [
  'Restangular', 'BookService',
  (Restangular,   BookService) ->
    _entries = null
    _current = null
    _pushing = false

    _setCurrent = (entry) ->
      return unless entry
      return if _current && _current.editing
      _current.isActive = false if _current
      _current = entry
      _current.isActive = true

      entryPromise = BookService.current.one('entries', _current.path).get()
      entry = entryPromise.$object

      entryPromise.then ->
        _current.content = entry.content
        _current.title = entry.title

    setCurrent: _setCurrent

    getCurrent: ->
      _current

    getPushing: ->
      _pushing

    fetch: ->
      _book = BookService.current

      _entriesPromise = BookService.current.getList('entries')
      _entries = _entriesPromise.$object

      _entriesPromise.then ->
        _setCurrent(_.first(_entries))

      _entries

    create: (entry) ->
      _book = BookService.current

      _book.post('entries', entry).then (newEntry) ->
        _entries.push newEntry
        _setCurrent(newEntry)

    push: ->
      _book = BookService.current
      entryPromise = _book.one('entries', 'push').post()
      _pushing = true

      entryPromise.then ->
        _pushing = false

    editing: ->
      _current.editing = true

    save: ->
      _current.saving = true
      entry = _current.save().$object

      _current.save().then ->
        console.log 'fucking', entry
        _current.saving = false
        _current.editing = false
        _current.title = entry.title
]
