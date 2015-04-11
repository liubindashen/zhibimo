class BookWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true

  def perform(book_id)
    Book.find(book_id).build
  end
end
