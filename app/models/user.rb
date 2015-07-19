class User < ActiveRecord::Base
  has_many :contacts

  def contacts_who_are_also_users
    self.contacts.select do |contact|
      User.find_by(phone_number: contact.phone_number)
    end
  end
end
