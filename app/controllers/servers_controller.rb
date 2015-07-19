class ServersController < ApplicationController
  def run
    # loop do
    #   sleep(20)
    #   @users = User.all
    #   mutual_contacts = {}
    #   # mutual_contacts_images = {}
    #   @users.each do |user|
    #     mutual_contacts[user.phone_number] = []
    #     # mutual_contacts_images[user.phone_number] = []
    #     user.contacts.each do |contact|
    #       reverse_user = User.find_by(phone_number: contact.phone_number)
    #       if reverse_user
    #         circular_user_array = reverse_user.contacts.select do |potential_circular_contact|
    #           potential_circular_contact.phone_number == user.phone_number
    #         end





    #           if circular_contact
    #             mutual_contacts[user.phone_number] = contact.phone_number
    #             # mutual_contacts_images[user.phone_number] = contact.image_url
    #           end
    #         end
    #       end
    #     end
    #   end
    #   @users.each do |user|
    #     mutual_contacts[user.phone_number].each do |mc|

    #     end
    #   end
    # end
  end
end
