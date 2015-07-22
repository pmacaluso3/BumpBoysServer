class ContactsController < ApplicationController
  def create
    @params = params
    puts "********************** params from a contacts request was #{params.inspect}"
    respond_to do |format|
      # format.html {render 'contacts/create'}
      format.json {render json: "You made it to create contact"}
    end

  end


  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :phone_number)
  end
end
