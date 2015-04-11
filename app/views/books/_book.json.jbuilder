json.extract! book, :id, :title, :slug, :created_at, :updated_at, :version, :version_time, :readme, :summary, :building

json.cover do
  json.preview_url book.cover.preview.url
  json.magazine_url book.cover.magazine.url
end

json.html_url "/read/#{book.user.username}/#{book.slug}/"
json.epub_url "/read/#{book.user.username}/#{book.slug}.epub"
json.pdf_url "/read/#{book.user.username}/#{book.slug}.pdf"

json.author do
  json.id book.user.id
  json.username book.user.username
  json.avatar_url book.user.avatar_url(image_url('avatar-default.png'))
end

if current_user == book.user
  json.git_url book.git_origin
end
