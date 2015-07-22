require 'json'
class ContactsController < ApplicationController
  def create
    new_contacts = []
    logger.info "**************** PARAMS ****************"
    logger.info "#{params.inspect}"
    logger.info "**************** END PARAMS ****************"

    logger.info "**************** REQUEST ****************"
    logger.info "#{request.inspect}"
    logger.info "**************** END REQUEST ****************"

    # contact_info = JSON.parse(params)
    params.each do |key,value|
      if key =~ /\Aperson/
        new_contacts << value
      end
    end
    @user = User.find_by(token: "<#{new_contacts[0][:user_token]}>")
    logger.info "****************************************** #{@user}"
    logger.info "****************************************** #{new_contacts}"
    @user.contacts.each {|c|c.destroy}
    new_contacts.each do |contact|
      contact[:last_name] = "" if contact[:last_name] == "null"
      Contact.create(first_name: contact[:first_name], last_name: contact[:last_name], phone_number: contact[:number], user_id: @user.id)
    end
    # @contact = Contact.create(contact_params_without_user_token)
    # @contact.user_id = @user.id
    # puts "********************** here's the new contact: #{@contact.inspect}"
    # puts "********************** params[:user_token] was #{params[:user_token]}"
    # puts "********************** params from a contacts request was #{params.inspect}"
    # if @contact.save
    #   puts "@@@@@@@@@@@@@@@@@@@@@@@@ the contact saved"
    # else
    #   puts "@@@@@@@@@@@@@@@@@@@@@@@@ the contact didn't save"
    # end
    respond_to do |format|
      format.html {render 'contacts/create'}
      format.json {render json: "You made it to create contact"}
    end


  end

end
