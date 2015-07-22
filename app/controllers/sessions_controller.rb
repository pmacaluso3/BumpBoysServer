class SessionsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    phone_number = format_phone_number(params[:phone_number])
    @user = User.find_by(phone_number)
    if @user.authenticate(params[:password])
      respond_to do |format|
        format.json {render json: {success: 1}}
      end
    else
      respond_to do |format|
        format.json {render json: {success: 0}}
      end
    end
    @params = params
    respond_to do |format|
      format.html {render 'sessions/create'}
      format.json {render json: "You made it to create session"}
    end
  end

  def new
  end

  private
  def login_params

  end
end
