require 'faker'



User.create(email: "jason@mail.com", password: 123123, avatar: Faker::Avatar.image, username: "jchee")

15.times do
  User.create(email: Faker::Internet.email, password: 123123, avatar: Faker::Avatar.image, username: Faker::Games::StreetFighter.move)
end
