class Signup < ActiveRecord::Base
  # Constants
  STATUS_NEW = 0
  STATUS_SUBSCRIBED = 1
  STATUS_INVITED = 2

  # Validations
  validates :email, presence: true, email: true, uniqueness: true
end
