class BuildBookJob < ActiveJob::Base
  queue_as :building

  def perform(book_id)
    book = Book.find_by_id(book_id)

    if book
      Slack.send "BUILDING START #{book.title}"
      Book.find(book_id).build
      Slack.send "BUILDING DONE  #{book.title}"
    else
      Slack.send "BUILDING NOTHING: Book##{book_id}"
    end
  rescue
    Slack.send "BUILDING ERROR: #{book.title}"
  end
end
