class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :token
      t.string :first_name
      t.string :last_name
      t.string :stored_phone_number
      t.references :user
      t.timestamps
    end
  end
end
