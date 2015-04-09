json.extract! book, :id, :title, :slug, :created_at, :updated_at

json.cover do
  json.preview_url book.cover.preview.url
  json.magazine_url book.cover.magazine.url
end

json.author do
  json.id book.author.id
  json.username book.author.username
  json.avatar_url book.author.avatar_url(image_url('avatar-default.png'))
end
