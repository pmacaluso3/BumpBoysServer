class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :udid
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.references :user
    end
  end
end
