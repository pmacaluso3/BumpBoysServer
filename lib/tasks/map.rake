desc "find the distances between mutual contacts"
task "map" do
  def send_apn(token,first,last)
    APN.certificate = File.read("config/initializers/bumpboys.pem")
    notification = Houston::Notification.new(device: token)
    notification.alert = "#{first} #{last} is now near you!"

    # Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
    notification.badge = 0
    notification.sound = "sosumi.aiff"
    notification.category = "INVITE_CATEGORY"
    notification.content_available = true
    notification.custom_data = {foo: "bar"}

    APN.push(notification)
  end

  feet_in_one_lat = 364402.01
  feet_in_one_lon = 272541.72

  # building a mutual contact list for each user
  @users = User.all
  @mutual_contacts_master = {}
  @users.each do |user|
    @mutual_contacts_master[user.stored_phone_number] = []
    mutual_users = user.contacts_who_are_also_users.map {|e|e.corresponding_user}
    mutual_users.each do |m_u|
      if m_u.has_as_contact?(user)
        @mutual_contacts_master[user.stored_phone_number] << m_u
      end
    end
  end
  # determining the distance to each mutual contact for each user
  @relationships = {}
  @mutual_contacts_master.each do |user_phone, mutual_contacts_list|
    @relationships[user_phone] = {}
    @user = User.find_by(stored_phone_number: user_phone)
    mutual_contacts_list.each do |mutual_contact|
      d_lat = mutual_contact.lat - @user.lat
      d_lon = mutual_contact.lon - @user.lon
      d_lat_in_feet = d_lat * feet_in_one_lat
      d_lon_in_feet = d_lon * feet_in_one_lon
      distance = (d_lat_in_feet**2 + d_lon_in_feet**2)**0.5
      @relationships[user_phone][mutual_contact.stored_phone_number] = distance
      # @relationships[user_token]["first_name"] = mutual_contact.first_name
      # @relationships[user_token]["last_name"] = mutual_contact.last_name
      # @relationships[user_token]["image_url"] = mutual_contact.image_url
      # @relationships[user_token]["udid"] = mutual_contact.udid
    end
  end

  # for each user, prepare the string of image urls for the mutual contacts within 1000 feet of that user
  # also, create an array of the tokens of all of this user's nearby friends

  if @relationships
    @relationships.each do |user_phone, mutual_contacts_list|
      u = User.find_by(stored_phone_number: user_phone)
      this_users_nearby_friends_images = []
      this_users_nearby_friends_tokens = []
      this_users_nearby_friends_tokens_previous = User.find_by(stored_phone_number: user_phone).nearby_friends_tokens.split(",")
      mutual_contacts_list.each do |mutual_contact_phone, distance|
        if distance < 1000
          this_users_nearby_friends_images << User.find_by(stored_phone_number: mutual_contact_phone).image_url
          this_users_nearby_friends_tokens << User.find_by(stored_phone_number: mutual_contact_phone).token
        end
      end
      u.nearby_friends_images = this_users_nearby_friends_images.join(",")
      # u.save
      # determine which friends are new to this user's radius, and send this user an apn for each one
      # finally, set this user's string of nearby user tokens to the new list
      new_friends_in_radius = this_users_nearby_friends_tokens - this_users_nearby_friends_tokens_previous
      new_friends_in_radius.each do |friend_token|
        friend = User.find_by(token: friend_token)
        send_apn(u.token, friend.first_name, friend.last_name)
      end
      # u = User.find_by(token: user_token)
      u.nearby_friends_tokens = this_users_nearby_friends_tokens.join(",")
      u.save
    end
  end
end
