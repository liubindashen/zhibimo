json.extract! @book, :id, :title, :slug, :created_at, :updated_at, :version, :version_time

json.html_url "http://zhibimo.com/read/#{@book.user.username}/#{@book.slug}/"
json.epub_url "http://zhibimo.com/read/#{@book.user.username}/#{@book.slug}.epub"
json.pdf_url "http://zhibimo.com/read/#{@book.user.username}/#{@book.slug}.pdf"
