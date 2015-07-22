class SessionsController < ApplicationController
  def create
    @params = params
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ params from session post was #{params.inspect}"
    render 'sessions/create'
  end

  def new
  end
end
