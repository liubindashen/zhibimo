angular.module('ngApp').controller 'BookEditController', [
  '$state', 'BookService', '$stateParams', '$upload'
  ($state,   BookService,   $stateParams,   $upload) ->
    vm = @

    BookService.one($stateParams['slug']).get().then (book) ->
      vm.book = book

    vm.submit = ->
      vm.book.save()

    vm.upload_cover = (files) ->
      $upload.upload
        url: "/api/v1/books/#{vm.book.id}.json"
        method: 'PUT'
        fields: { 'book[id]': vm.book.id}
        file: files[0]
        fileFormDataName: 'book[cover]'
      .success (book, status) ->
        vm.book.cover.preview_url = book.cover.preview_url

    vm.delete = ->
      vm.book.remove()
      $state.go 'dashboard.books.index'

    return vm
]
