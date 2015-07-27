class Order < ActiveRecord::Base
  self.primary_key = :id

  include AASM

  belongs_to :book
  belongs_to :author
  belongs_to :purchaser, class_name: 'User'

  validates_presence_of :id, :aasm_state, :fee
  validates_presence_of :wx_prepay_id, :wx_code_url, on: :update

  aasm do
    state :idle, initial: true
    state :waiting
    state :complete

    event :wait do
      transitions :from => [:idle, :waiting], :to => :waiting
    end

    event :done do
      transitions :from => [:idle, :waiting], :to => :complete
    end
  end
end
