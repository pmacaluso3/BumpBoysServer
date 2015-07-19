# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

bo = User.create!(udid: "1",
  first_name: "Bo",
  last_name: "Guthrie",
  phone_number: "2058070850",
  image_url: "https://pbs.twimg.com/profile_images/443395868134088704/enQ-y1aY.jpeg",
  lat: 41.898378,
  lon: -87.635513
  )

nick = User.create!(udid: "2",
  first_name: "Nick",
  last_name: "Siefken",
  phone_number: "3096455208",
  image_url: "https://pbs.twimg.com/profile_images/3406647874/55e6e2b3a2cd929d478213bca7ea346a.jpeg",
  lat: 41.888378,
  lon: -87.636513
  )

pete = User.create!(udid: "3",
  first_name: "Pete",
  last_name: "Macaluso",
  phone_number: "8132634315",
  image_url: "https://pbs.twimg.com/profile_images/580334037211975680/ZYqCIBVb.jpg",
  lat: 0.0,
  lon: 0.0
  )



bo_contact = Contact.create!(udid: "",
  first_name: "Bo",
  last_name: "Guthrie",
  phone_number: "2058070850")

nick_contact = Contact.create!(udid: "",
  first_name: "Nick",
  last_name: "Siefken",
  phone_number: "3096455208")

steve_contact = Contact.create!(udid: "",
  first_name: "Steve",
  last_name: "Dude",
  phone_number: "1234567890")

bo.contacts << nick_contact
nick.contacts << bo_contact
pete.contacts << steve_contact
