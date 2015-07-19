class ServersController < ApplicationController
  def run
    i = 0
    loop do
      # building a mutual contact list for each user
      @users = User.all
      @mutual_contacts = {}
      @users.each do |user|
        @mutual_contacts[user.phone_number] = []
        mutual_users = user.contacts_who_are_also_users.map {|e|e.corresponding_user}
        mutual_users.each do |m_u|
          if m_u.has_as_contact?(user)
            @mutual_contacts[user.phone_number] << m_u
          end
        end
      end
      puts "************** #{@mutual_contacts.inspect}"
      # determining the distance to each mutual contact for each user
      i += 1
      puts "$$$$$$$$$$$$$$ loop number #{i}"
      sleep(20)
    end
    render 'runs/info'
  end
end
