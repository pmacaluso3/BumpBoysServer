class DistancesController < ApplicationController
  def calculate
    lat = params[:lat].to_f
    lon = params[:lon].to_f
    feet_in_one_lat = 364402.01
    feet_in_one_lon = 272541.72

#NY
    # mm_lat = 40.759011
    # mm_lon = -73.984472

#merch mart
    mm_lat = 41.888378
    mm_lon = -87.636513

    d_lat = lat - mm_lat
    d_lon = lon - mm_lon
    d_lat_in_feet = d_lat*feet_in_one_lat
    d_lon_in_feet = d_lon*feet_in_one_lon
    dist_in_feet = (d_lat_in_feet**2 + d_lon_in_feet**2)**0.5
    hash = {lat: lat,
      lon: lon,
      feet_in_one_lat: feet_in_one_lat,
      feet_in_one_lon: feet_in_one_lon,
      mm_lat: mm_lat,
      mm_lon: mm_lon,
      d_lat: d_lat,
      d_lon: d_lon,
      d_lat_in_feet: d_lat_in_feet,
      d_lon_in_feet: d_lon_in_feet,
      dist_in_feet: dist_in_feet
    }
    @hash = hash



    respond_to do |format|
      format.json {render json: hash}
      format.html {render 'distances/show'}
    end
  end

  def update
    @user = User.find_by(token: "<#{params[:token]}>")
    @user.lat =  params[:lat].to_f
    @user.lon = params[:lon].to_f
    @user.save
    log = ""
    File.open("/Users/apprentice/Desktop/logs.txt", "r") {|f| log += f.read}
    log += "#{@user.lat}, #{@user.lon}\n"
    File.open("/Users/apprentice/Desktop/logs.txt", "w+") {|f| f.write(log)}
    # puts "&&&&&&&&&&&&&&&&&&&&&& #{@use}"
    @nearby_friends = @user.nearby_friends_images.split(",")
    if @nearby_friends.empty?
      @nearby_friends << "http://www.rollitup.org/proxy.php?image=http%3A%2F%2Fwww.esreality.com%2Ffiles%2Fplaceimages%2F2013%2F99064-yo-dawg-i-heard-you-have-no-friends-30.jpeg&hash=b7655b7718dfb6c45f7bbee04ed90d00"
    end
    puts "<<<<<<<<<<<<<<<<<<<<<<<< #{@nearby_friends}"
    respond_to do |format|
      format.json {render json: {images: @nearby_friends}}
      format.html {render 'distances/show'}
    end
  end

  def location_params
    # params.permit
  end




end
