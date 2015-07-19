class User < ActiveRecord::Base
  has_many :contacts

  def contacts_who_are_also_users
    self.contacts.select do |contact|
      User.find_by(phone_number: contact.phone_number)
    end
  end

  def has_as_contact?(test_contact)
    self.contacts.select do |contact|
      contact.phone_number == test_contact.phone_number
    end.any?
  end
end
