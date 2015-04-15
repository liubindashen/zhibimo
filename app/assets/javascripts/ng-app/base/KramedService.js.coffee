angular.module('ngApp')
  .factory 'KramedService', ->
    render: (content) ->
      kramed(content)
