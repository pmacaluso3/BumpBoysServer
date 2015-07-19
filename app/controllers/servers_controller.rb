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
        @mutual_contacts_master[user.token] = []
        mutual_users = user.contacts_who_are_also_users.map {|e|e.corresponding_user}
        mutual_users.each do |m_u|
          if m_u.has_as_contact?(user)
            @mutual_contacts_master[user.token] << m_u
          end
        end
      end

      # determining the distance to each mutual contact for each user
      @relationships = {}
      @mutual_contacts_master.each do |user_token, mutual_contacts_list|
        @relationships[user_token] = {}
        @user = User.find_by(token: user_token)
        mutual_contacts_list.each do |mutual_contact|
          d_lat = mutual_contact.lat - @user.lat
          d_lon = mutual_contact.lon - @user.lon
          d_lat_in_feet = d_lat * feet_in_one_lat
          d_lon_in_feet = d_lon * feet_in_one_lon
          distance = (d_lat_in_feet**2 + d_lon_in_feet**2)**0.5
          @relationships[user_token][mutual_contact.token] = distance
          # @relationships[user_token]["first_name"] = mutual_contact.first_name
          # @relationships[user_token]["last_name"] = mutual_contact.last_name
          # @relationships[user_token]["image_url"] = mutual_contact.image_url
          # @relationships[user_token]["udid"] = mutual_contact.udid
        end
      end

      # for each user, prepare the string of image urls for the mutual contacts within 1000 feet of that user
      # also, create a string of the tokens of all of this user's nearby friends
      @relationships.each do |user_token, mutual_contacts_list|
        this_users_nearby_friends_images = []
        this_users_nearby_friends_tokens = []
        this_users_nearby_friends_tokens_previous = User.find_by(token: user_token).nearby_friends_tokens.split(",")
        mutual_contacts_list.each do |mutual_contact_token, distance|
          if distance < 1000
            this_users_nearby_friends_images << User.find_by(token: mutual_contact_token).image_url
            this_users_nearby_friends_tokens << mutual_contact_token
          end
        end
        User.find_by(token: user_token).nearby_friends_images = this_users_nearby_friends_images.join(",")
        new_friends_in_radius = this_users_nearby_friends_tokens - this_users_nearby_friends_tokens_previous
        new_friends_in_radius.each do |friend_token|

        end
      end

      # for each user, prepare the list of people this user should receive push notifications about
      @relationships.each do |user_token, mutual_contacts_list|
        mutual_contacts_list.each do |mutual_contact_token, distance|
          if distance < 1000

          end
        end
      end


    # end
    render 'runs/info'
  end
end
