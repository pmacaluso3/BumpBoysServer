class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save

    else

    end
  end


  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number)
  end
end


