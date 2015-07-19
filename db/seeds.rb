# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

bo = User.create!(udid: nil,
  first_name: "Bo",
  last_name: "Guthrie"
  phone_number: "2058070850",
  image_url: "https://pbs.twimg.com/profile_images/443395868134088704/enQ-y1aY.jpeg")

nick = User.create!(udid: nil,
  first_name: "Nick",
  last_name: "Siefken"
  phone_number: "3096455208",
  image_url: "https://pbs.twimg.com/profile_images/3406647874/55e6e2b3a2cd929d478213bca7ea346a.jpeg")


bo_contact = Contact.create! (udid: nil,
  first_name: "Bo",
  last_name: "Guthrie"
  phone_number: "2058070850")

nick_contact = Contact.create! (udid: nil,
  first_name: "Nick",
  last_name: "Siefken"
  phone_number: "3096455208")

bo.contacts << nick
nick.contacts << bo
