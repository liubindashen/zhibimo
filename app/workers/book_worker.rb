class BookWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true

  def perform(payload)
    Book.from_hook(payload)
  end
end
