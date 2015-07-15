class Build < ActiveRecord::Base
  validates_presence_of :name, :email, :message, :at
  
  after_create do
    BuildJob.perform_later(id)
  end
end
