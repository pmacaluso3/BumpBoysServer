require 'json'
class ContactsController < ApplicationController
  def build
    new_contacts = []
    params.each do |key,value|
      if key =~ /\Aperson/
        new_contacts << value
      end
    end
    @user = User.find_by(token: "<#{new_contacts[0][:user_token]}>")
    @user.contacts.each {|c|c.destroy}
    old_numbers = @user.contacts.map{|c|c.stored_phone_number}
    new_numbers = new_contacts.map{|c|c.number}
    numbers_to_delete = old_numbers - new_numbers
    numbers_to_delete.each do |number|
      c = Contact.find_by(user_id: @user.id, stored_phone_number: number)
      c.destroy
    end
    new_contacts.each do |contact|
      contact[:last_name] = "" if contact[:last_name] == "null"
      c = Contact.new(first_name: contact[:first_name], last_name: contact[:last_name], phone_number: contact[:number], user: @user)
    end
    respond_to do |format|
      format.html {render 'contacts/create'}
      format.json {render json: "You made it to create contact"}
    end
  end


  def create
    @user = User.find_by(id: params[:user_id])
    @contact = User.find_by(id: params[:contact_id])
    Contact.create(first_name: @contact.first_name, last_name: @contact.last_name, stored_phone_number: @contact.stored_phone_number, user: @user)
    redirect_to '/'
  end

  private
  def contact_params

  end

end
