class ServersController < ApplicationController
  def run
    feet_in_one_lat = 364402.01
    feet_in_one_lon = 272541.72
    # i = 0
    # loop do
      # building a mutual contact list for each user
      @users = User.all
      @mutual_contacts_master = {}
      @users.each do |user|
        @mutual_contacts_master[user.phone_number] = []
        mutual_users = user.contacts_who_are_also_users.map {|e|e.corresponding_user}
        mutual_users.each do |m_u|
          if m_u.has_as_contact?(user)
            @mutual_contacts_master[user.phone_number] << m_u
          end
        end
      end

      # determining the distance to each mutual contact for each user
      @relationships = {}
      @mutual_contacts_master.each do |user_phone_number, mutual_contacts_list|
        @relationships[user_phone_number] = {}
        @user = User.find_by(phone_number: user_phone_number)
        mutual_contacts_list.each do |mutual_contact|
          d_lat = mutual_contact.lat - @user.lat
          d_lon = mutual_contact.lon - @user.lon
          d_lat_in_feet = d_lat * feet_in_one_lat
          d_lon_in_feet = d_lon * feet_in_one_lon
          distance = (d_lat_in_feet**2 + d_lon_in_feet**2)**0.5
          @relationships[user_phone_number]["distance"] = distance
          @relationships[user_phone_number]["first_name"] = mutual_contact.first_name
          @relationships[user_phone_number]["last_name"] = mutual_contact.last_name
          @relationships[user_phone_number]["image_url"] = mutual_contact.image_url
          @relationships[user_phone_number]["udid"] = mutual_contact.udid
        end
      end

    # end
    render 'runs/info'
  end
end
