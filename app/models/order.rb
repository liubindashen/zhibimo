class Order < ActiveRecord::Base
  self.primary_key = :id

  validates_presence_of :id, :aasm_state, :fee
  validates_presence_of :wx_prepay_id, :wx_code_url, on: :update

  before_validation :generate_id
  
  def generate_id
    self.id = DateTime.now.strftime '%y%m%d%H%M%S%L%3N'
  end
end
