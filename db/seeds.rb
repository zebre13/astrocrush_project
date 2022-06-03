# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative '../app/models/user'
require 'city-state'
require 'faker'
require 'open-uri'

puts "Cleaning database..."
User.destroy_all

puts 'Creating 10 fake users...'
10.times do
  random_country_key = CS.countries.to_a.sample.first
  random_state_key = CS.states(random_country_key).to_a.sample.first
  user = User.create!(
    username: Faker::Name.first_name,
    email: Faker::Internet.safe_email,
    password: 'azerty',
    description: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false),
    hobbies: Faker::Hobby.activity, # BOB: to update when hobbies is changed from f.input to f.select
    # photos:
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
    birth_hour: "#{rand(0..23).to_s.rjust(2, '0')}:#{rand(0..59).to_s.rjust(2, '0')}",
    birth_location: "#{CS.cities(random_state_key, random_country_key).sample} (#{CS.states(random_country_key)[random_state_key]}, #{CS.countries[random_country_key]})",
    gender: Faker::Gender.binary_type,
    looking_for: Faker::Gender.binary_type
  )
  file = URI.open('https://thispersondoesnotexist.com/image')
  user.photos.attach(io: file, filename: 'user.png', content_type: 'image/png')
end

puts 'Finished!'

# User.create(email: 'test@test.com', password: '123456')
# User.create(email: '@test.com', password: '123456')
