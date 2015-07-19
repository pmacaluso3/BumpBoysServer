class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :udid
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :image_url
      t.float :lat
      t.float :lon
    end
  end
end
