class Contact < ActiveRecord::Base
  belongs_to :user

  def corresponding_user
    User.find_by(phone_number: self.phone_number)
  end
end
