class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :token
      t.string :first_name
      t.string :last_name
      t.string :stored_phone_number
      t.string :image_url
      t.float :lat, default: 0.0
      t.float :lon, default: 0.0
      t.string :nearby_friends_infos, default: ""
      t.string :nearby_friends_tokens, default: ""
      t.string :password_digest
      t.timestamps
    end
  end
end
