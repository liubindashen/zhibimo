angular.module('myApp')
  .factory 'kramedService', ->
    render: (content) ->
      kramed(content)
