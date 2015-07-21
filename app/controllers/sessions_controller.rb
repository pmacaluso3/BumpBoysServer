class SessionsController < ApplicationController
  def create
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ params from session post was #{params.inspect}"
  end
end
