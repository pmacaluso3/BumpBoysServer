class Contact < ActiveRecord::Base
  belongs_to :user

  def corresponding_user
    User.find_by(stored_phone_number: self.phone_number)
  end

  def phone_number=(incoming_number)
    self.stored_phone_number = incoming_number.gsub(/\D/,"").gsub(/\A1/,"")
  end

  def phone_number
    self.stored_phone_number
  end
end
