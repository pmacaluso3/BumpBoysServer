class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.token = "<#{@user.token}>"
    @user.password = "password"
    if @user.save
      redirect_to "/"
    else
      render "users/index"
    end
  end

  def new
  end

  def show
    @user = User.find_by(id: params[:id])
    @users = User.all
  end


  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :stored_phone_number, :token, :image_url)
  end
end


