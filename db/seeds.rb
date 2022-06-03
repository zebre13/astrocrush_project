# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

puts 'Creating 100 fake users...'

100.times do
  user = User.new(
    username:       Faker::Name.first_name,
    email:          Faker::Internet.free_email(name: :username.to_s),
    password:       'azerty',
    description:    Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false),
    hobbies:        Faker::Hobby.activity, #TODO: pour l'instant un seul hobby renseigné en mode input => à changer en mode sélection dans liste plus tard
    # photos:
    birth_date:     Faker::Date.birthday(min_age: 18, max_age: 65),
    birth_hour:     "#{rand(0..23).to_s.rjust(2, '0')}:#{rand(0..59).to_s.rjust(2, '0')}"
    birth_location: 'Paris',
    gender:         Faker::Gender.binary_type,
    looking_for:    Faker::Gender.binary_type


    # address: "#{Faker::Address.street_address}, #{Faker::Address.city}",
    # rating:  rand(0..5)
  )
  user.save!
end
puts 'Finished!'


User.create(email: 'test@test.com', password: '123456')
User.create(email: '@test.com', password: '123456')
