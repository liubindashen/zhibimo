class BookWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true

  def perform(id)
    book = Book.find(id)
    return if book.building?
    book.update_attributes(building: true)
    system("gitbook build #{book.workdir} /tmp/books/#{book.user.username}/#{book.id}")
    book.update_attributes(building: false)
  rescue => e
    puts e
    book.update_attributes(building: false)
  end
end
