require 'houston'
APN = Houston::Client.development

class ServersController < ApplicationController
  def update
    @user = User.find_by(token: "<#{params[:token]}>")
    @user.lat =  params[:lat].to_f
    @user.lon = params[:lon].to_f
    @user.lat_lon_log += "#{@user.lat}, #{@user.lon};"
    @user.save
    puts "**************************** #{@user.lat_lon_log}"
    @nearby_friends = @user.nearby_friends_images.split(",")
    if @nearby_friends.empty?
      @nearby_friends << "http://www.rollitup.org/proxy.php?image=http%3A%2F%2Fwww.esreality.com%2Ffiles%2Fplaceimages%2F2013%2F99064-yo-dawg-i-heard-you-have-no-friends-30.jpeg&hash=b7655b7718dfb6c45f7bbee04ed90d00"
    end
    puts "<<<<<<<<<<<<<<<<<<<<<<<< #{@nearby_friends}"
    respond_to do |format|
      format.json {render json: {images: @nearby_friends}}
      format.html {render 'distances/show'}
    end
    request_counter = RequestCounter.first
    request_counter.counter += 1
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ there have been #{request_counter.counter} requests since the last tick"
    request_counter.save
    if request_counter.counter >= User.all.length
      request_counter.counter = 0
      request_counter.save
      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ running the server..."
      run
    end
  end

  def run
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@ run was triggered..."
    feet_in_one_lat = 364402.01
    feet_in_one_lon = 272541.72

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
      # also, create an array of the tokens of all of this user's nearby friends
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
        u = User.find_by(token: user_token)
        u.nearby_friends_images = this_users_nearby_friends_images.join(",")
        u.save

        # determine which friends are new to this user's radius, and send this user an apn for each one
        # finally, set this user's string of nearby user tokens to the new list
        new_friends_in_radius = this_users_nearby_friends_tokens - this_users_nearby_friends_tokens_previous
        # puts ">>>>>>>>>>>>>>>>>>>> #{new_friends_in_radius}"
        new_friends_in_radius.each do |friend_token|
          friend = User.find_by(token: friend_token)
          puts "^^^^^^^^^^^^^^^^^^^^^^^ #{friend.first_name} #{friend.last_name} (token = #{user_token}) is now near you!"
          send_apn(user_token, friend.first_name, friend.last_name)
        end
        u = User.find_by(token: user_token)
        u.nearby_friends_tokens = this_users_nearby_friends_tokens.join(",")
        u.save
        puts "&&&&&&&&&&&&&&&&&&&&&& #{User.find_by(token: user_token).nearby_friends_tokens}"
        puts "&&&&&&&&&&&&&&&&&&&&&& #{User.find_by(token: user_token).nearby_friends_images}"
      end

    # end
    # render 'runs/info'
  end

  private
  def send_apn(token,first,last)v
    APN.certificate = File.read("config/initializers/bumpboys.pem")
    notification = Houston::Notification.new(device: token)
    notification.alert = "#{first} #{last} is now near you!"

    # Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
    notification.badge = 57
    notification.sound = "sosumi.aiff"
    notification.category = "INVITE_CATEGORY"
    notification.content_available = true
    notification.custom_data = {foo: "bar"}
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!#{notification.inspect}"
    # And... sent! That's all it takes.
    APN.push(notification)

  end

end
