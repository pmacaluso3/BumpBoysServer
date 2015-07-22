class SessionsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    @params = params
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ params from session post was #{params.inspect}"
    respond_to do |format|
      format.html {render 'sessions/create'}
      format.json {render json: "You made it to create session"}
    end


  end

  def new
  end
end
