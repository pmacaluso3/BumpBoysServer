class SessionsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    phone_number = format_phone_number(params[:phone_number])
    @user = User.find_by(stored_phone_number: phone_number)
    if @user.authenticate(params[:password])
      respond_to do |format|
        format.json {render json: {success: 1}}
      end
    else
      respond_to do |format|
        format.json {render json: {success: 0}}
      end
    end
  end

  def new
  end

  private
  def login_params

  end
end
