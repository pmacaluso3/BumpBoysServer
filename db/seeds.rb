# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

bo = User.create!(token: "<b13e2dca0322957b7934a6b1f4d500f8dd7b59724db65f6f92f3a1072a31bbf4>",
  first_name: "Bo",
  last_name: "Guthrie",
  stored_phone_number: "2058070850",
  image_url: "https://pbs.twimg.com/profile_images/443395868134088704/enQ-y1aY.jpeg",
  lat: 41.898378,
  lon: -87.635513,
  nearby_friends_infos: "",
  nearby_friends_tokens: "",
  password: "password"
  )

nick = User.create!(token: "<1ec07cbae464fde4a109f64646aae9a6fb04101a066bd74d05c9b402fec379ca>",
  first_name: "Nick",
  last_name: "Siefken",
  stored_phone_number: "3096455208",
  image_url: "https://pbs.twimg.com/profile_images/3406647874/55e6e2b3a2cd929d478213bca7ea346a.jpeg",
  lat: 41.888378,
  lon: -87.636513,
  nearby_friends_infos: "",
  nearby_friends_tokens: "",
  password: "password"
  )

pete = User.create!(token: "<3>",
  first_name: "Pete",
  last_name: "Macaluso",
  stored_phone_number: "8132634315",
  image_url: "https://pbs.twimg.com/profile_images/580334037211975680/ZYqCIBVb.jpg",
  lat: 41.788378,
  lon: -87.836513,
  nearby_friends_infos: "",
  nearby_friends_tokens: "",
  password: "password"
  )



bo_contact = Contact.create!(
  first_name: "Bo",
  last_name: "Guthrie",
  stored_phone_number: "2058070850")

nick_contact = Contact.create!(
  first_name: "Nick",
  last_name: "Siefken",
  stored_phone_number: "3096455208")

pete_contact = Contact.create!(
  first_name: "Pete",
  last_name: "Macaluso",
  stored_phone_number: "8132634315")


bo.contacts.create(
  first_name: "Nick",
  last_name: "Siefken",
  stored_phone_number: "3096455208")
nick.contacts << bo_contact
pete.contacts << nick_contact
nick.contacts << pete_contact

