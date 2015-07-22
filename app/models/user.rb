class User < ActiveRecord::Base
  has_many :contacts
  has_secure_password

  def contacts_who_are_also_users
    self.contacts.select do |contact|
      User.find_by(stored_phone_number: contact.phone_number)
    end
  end

  def has_as_contact?(test_contact)
    self.contacts.select do |contact|
      contact.phone_number == test_contact.phone_number
    end.any?
  end

  def phone_number=(incoming_number)
    self.stored_phone_number = incoming_number.gsub(/\D/,"").gsub(/\A1/,"")
  end

  def phone_number
    self.stored_phone_number
  end

end

