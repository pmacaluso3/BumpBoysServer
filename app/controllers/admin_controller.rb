class AdminController < ApplicationController

  def index
    @users = User.all
  end

  def move
    @user1 = User.find_by(id: params[:user1_id])
    @user2 = User.find_by(id: params[:user2_id])
    @user1.lat = @user2.lat
    @user1.lon = @user2.lon
    @user1.save
    redirect_to "/"
  end

  def move0
    puts "********************* #{params.inspect}"
    @user = User.find_by(id: params[:id])
    puts "***************************** #{@user.inspect}"
    @user.lat = 0.0
    @user.lon = 0.0
    @user.save
    redirect_to "/"
  end
end
