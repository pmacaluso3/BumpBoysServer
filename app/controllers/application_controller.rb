  # require 'houston'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def format_phone_number(incoming_number)
    incoming_number.gsub(/\D/,"").gsub(/\A1/,"")
  end
end
