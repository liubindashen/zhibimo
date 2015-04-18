angular.module('ngApp').factory 'EntriesService', [
  'Restangular', 'BookService',
  (Restangular,   BookService) ->
    _book = null
    _bookSlug = null
    _entries = null
    _current = null
    _currentWithDetail = null

    _setCurrent = (entry) ->
      _current.isActive = false if _current
      _current = entry
      _current.isActive = true

      _currentWithDetail = BookService
        .one(_bookSlug)
        .one('entries', _current.id).get().$object

    setCurrent: _setCurrent

    getCurrent: -> 
      _current

    getCurrentWithDetail: ->
      _currentWithDetail

    fetch: (bookSlug) ->
      _bookSlug = bookSlug
      _book = BookService.one(_bookSlug).get().$object

      _entriesPromise = BookService.one(_bookSlug).getList('entries')
      _entries = _entriesPromise.$object

      _entriesPromise.then ->
        _setCurrent(_.first(_entries))

      [_book, _entries]

    create: (entry) ->
      _book.post('entries', entry).then (newEntry) ->
        _entries.push newEntry
        _setCurrent(newEntry)

    save: ->
      _currentWithDetail.saving = true
      _currentWithDetail.save().then ->
        _currentWithDetail.saving = false

]
