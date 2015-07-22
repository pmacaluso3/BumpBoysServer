class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :token
      t.string :first_name
      t.string :last_name
      t.string :stored_phone_number
      t.string :image_url
      t.float :lat
      t.float :lon
      t.string :nearby_friends_images
      t.string :nearby_friends_tokens
      t.string :password_digest
      t.timestamps
    end
  end
end
