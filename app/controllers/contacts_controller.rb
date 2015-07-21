class ContactsController < ApplicationController
  def create
    @params = params
    puts "********************** params from a contacts request was #{params.inspect}"
  end


  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :phone_number)
  end
end
