# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
dum = User.create!(token: "0",
  first_name: "Dum",
  last_name: "Dum",
  phone_number: "dum_number",
  image_url: "https://pbs.twimg.com/profile_images/443395868134088704/enQ-y1aY.jpeg",
  lat: 41.898378,
  lon: -87.635513,
  nearby_friends_images: "",
  nearby_friends_tokens: ""
  )

bo = User.create!(token: "<b13e2dca0322957b7934a6b1f4d500f8dd7b59724db65f6f92f3a1072a31bbf4>",
  first_name: "Bo",
  last_name: "Guthrie",
  phone_number: "bo_number",
  image_url: "https://pbs.twimg.com/profile_images/443395868134088704/enQ-y1aY.jpeg",
  lat: 41.898378,
  lon: -87.635513,
  nearby_friends_images: "",
  nearby_friends_tokens: ""
  )

nick = User.create!(token: "<1ec07cbae464fde4a109f64646aae9a6fb04101a066bd74d05c9b402fec379ca>",
  first_name: "Nick",
  last_name: "Siefken",
  phone_number: "nick_number",
  image_url: "https://pbs.twimg.com/profile_images/3406647874/55e6e2b3a2cd929d478213bca7ea346a.jpeg",
  lat: 41.888378,
  lon: -87.636513,
  nearby_friends_images: "",
  nearby_friends_tokens: ""
  )

pete = User.create!(token: "3",
  first_name: "Pete",
  last_name: "Macaluso",
  phone_number: "pete_number",
  image_url: "https://pbs.twimg.com/profile_images/580334037211975680/ZYqCIBVb.jpg",
  lat: 41.788378,
  lon: -87.836513,
  nearby_friends_images: "",
  nearby_friends_tokens: ""
  )



bo_contact = Contact.create!(token: "<7e4cdfd5e12553d49e55e33e17ee8f760415583f46c758b2fb9360afcaf26c8d>",
  first_name: "Bo",
  last_name: "Guthrie",
  phone_number: "bo_number")

nick_contact = Contact.create!(token: "<e2617728ad6e8b2b656a56a37489d42c4224e28eae6ca47ab665bdd6a5001f03>",
  first_name: "Nick",
  last_name: "Siefken",
  phone_number: "nick_number")

pete_contact = Contact.create!(token: "3",
  first_name: "Pete",
  last_name: "Macaluso",
  phone_number: "pete_number")

steve_contact = Contact.create!(token: "4",
  first_name: "Steve",
  last_name: "Dude",
  phone_number: "1234567890")

bo.contacts.create(token: "<e2617728ad6e8b2b656a56a37489d42c4224e28eae6ca47ab665bdd6a5001f03>",
  first_name: "Nick",
  last_name: "Siefken",
  phone_number: "nick_number")
puts bo.contacts.inspect
# puts bo.contacts.inspect
nick.contacts << bo_contact
# puts nick.contacts.inspect
pete.contacts << nick_contact
# nick.contacts = [pete_contact, bo_contact]
# puts pete.contacts.inspect
nick.contacts << pete_contact
# puts nick.contacts.inspect
pete.contacts << steve_contact
# puts pete.contacts.inspect

puts User.second.inspect
