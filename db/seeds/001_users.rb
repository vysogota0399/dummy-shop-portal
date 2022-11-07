require 'faker'

User.destroy_all

User.create(
  first_name: 'admin',
  middle_name: Faker::Name.middle_name,
  last_name: Faker::Name.last_name,
  email: 'admin@mail.ru',
  password: '123456'
)

10.times do 
  first_name = Faker::Name.first_name
  email = "#{first_name}@mail.ru"
  User.create(
    first_name: first_name,
    middle_name: Faker::Name.middle_name,
    last_name: Faker::Name.last_name,
    email: email,
    password: '123456'
  )
end