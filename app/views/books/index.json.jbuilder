json.array!(@books) do |book|
  json.extract! book, :id, :title, :slug
  json.url book_url(book, format: :json)
end
