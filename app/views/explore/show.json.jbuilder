json.partial! 'explore/book', book: @book
json.extract! @book, :readme, :summary
json.html_url "/read/#{@book.author.username}/#{@book.slug}/"
json.epub_url "/read/#{@book.author.username}/#{@book.slug}.epub"
json.pdf_url "/read/#{@book.author.username}/#{@book.slug}.pdf"
