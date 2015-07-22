class ContactsController < ApplicationController
  def create
    @params = params
    @user = User.find_by("<#{user_token}>")
    @contact = Contact.create(contact_params_without_user_token)
    @contact.user_id = @user.id
    puts "********************** here's the new contact: #{@contact.inspect}"
    puts "********************** params[:user_token] was #{params[:user_token]}"
    puts "********************** params from a contacts request was #{params.inspect}"
    if @contact.save
      puts "@@@@@@@@@@@@@@@@@@@@@@@@ the contact saved"
    else
      puts "@@@@@@@@@@@@@@@@@@@@@@@@ the contact didn't save"
    end
    respond_to do |format|
      format.html {render 'contacts/create'}
      format.json {render json: "You made it to create contact"}
    end

  end


  private

  def contact_params
    params.require(:person).permit(:first_name, :last_name, :phone_number, :user_token)
  end

  def contact_params_without_user_token
    params.require(:person).permit(:first_name, :last_name, :phone_number)
  end

  def user_token
    params.require(:person).permit(:user_token)
  end

end
