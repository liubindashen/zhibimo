class Withdraw < ActiveRecord::Base
  extend Enumerize

  belongs_to :author
  enumerize :state, in: [:wait, :reject, :complete], default: :wait

end
