require 'open-uri'
require 'faker'
require_relative '../app/services/astrology_api'

api_uid = ENV["API_UID"]
api_key = ENV["API_KEY"]

puts 'Cleaning database...'

User.destroy_all
Match.destroy_all
Chatroom.destroy_all

puts 'Creating team users'

boris_data = {
  username: 'Boris',
  email: 'boris_bourdet@hotmail.com',
  password: 'azerty',
  description: 'Si ça vous dit, je connais un très bon thai de la rue Oberkampf',
  hobbies: 'Faire des concerts dans mon salon',
  birth_date: '26/06/1977',
  birth_hour: '05:30',
  birth_location: 'Aix-en-Provence',
  birth_country: 'FR',
  gender: 1,
  looking_for: 2,
  sign: 'cancer',
  rising: 'gémeaux',
  moon: 'balance'
}

etienne_data = {
  username: 'Etienne',
  email: 'etiennededi@hotmail.fr',
  password: 'azerty',
  description: "Si toi aussi tu aimes coder en peignoir, on est faits pour s'entendre",
  hobbies: 'Mettre en musique des séries cultes',
  birth_date: '23/06/1994',
  birth_hour: '06:30',
  birth_location: 'Paris',
  birth_country: 'FR',
  gender: 1,
  looking_for: 2,
  sign: 'Cancer',
  rising: 'Cancer',
  moon: 'Sagittaire'
}

ghita_data = {
  username: 'Ghita',
  email: 'aa.ghita@gmail.com',
  password: 'azerty',
  description: "Attention, je suis très cool mais si tu m'énerves c'est coup de boule direct",
  hobbies: 'Organiser des festivals techno',
  birth_date: '23/07/1988',
  birth_hour: '07:30',
  birth_location: 'Casablanca',
  birth_country: 'MA',
  gender: 2,
  looking_for: 1,
  sign: 'Lion',
  rising: 'Lion',
  moon: 'Scorpion'
}

maria_data = {
  username: 'Maria',
  email: 'leonor.varela91330@gmail.com',
  password: 'azerty',
  description: "J'ai inspiré le tube Maria Maria à Carlos Santana",
  hobbies: 'Fiesta',
  birth_date: '15/08/1993',
  birth_hour: '15:15',
  birth_location: 'Cascais',
  birth_country: 'PT',
  gender: 2,
  looking_for: 1,
  sign: 'Lion',
  rising: 'Scorpion',
  moon: 'Cancer'
}

users_data = [boris_data, etienne_data, ghita_data, maria_data]

photo_boris = File.open(Rails.root.join("public/seed_images/boris.jpg"))
photo_etienne = File.open(Rails.root.join("public/seed_images/etienne.jpg"))
photo_ghita = File.open(Rails.root.join("public/seed_images/ghita.jpg"))
photo_maria = File.open(Rails.root.join("public/seed_images/maria.jpg"))

photos = [photo_boris, photo_etienne, photo_ghita, photo_maria]

users_data.each_with_index do |user_data, index|
  user = User.new(user_data)
  user.planets = Call.new(api_uid, api_key).planets_location(user.birth_date, user.birth_hour, user.birth_location, user.birth_country)
  user.photos.attach(io: photos[index], filename: user.username, content_type: 'jpg')
  user.save!
end

puts 'Team users created succesfully'

maria = User.find_by_email('leonor.varela91330@gmail.com')
boris = User.find_by_email('boris_bourdet@hotmail.com')
etienne = User.find_by_email('etiennededi@hotmail.fr')

puts "user created"

puts 'Creating Matches...'
Chatroom.new.save!

puts "first chatroom ok "

first_match = {
  status: "accepted",
  user_id: maria.id,
  mate_id: boris.id,
  chatroom_id: Chatroom.first.id
}

Chatroom.new.save!
puts "second chatroom ok
"
second_match = {
  status: "accepted",
  user_id: maria.id,
  mate_id: etienne.id,
  chatroom_id: Chatroom.last.id
}

matches = [first_match, second_match]

# first_score = 80

matches.each do |match|
  match_instance = Match.new(match)
  match_instance.save

  # first_score.save
end

# puts 'Creating 10 fake users...'

# 10.times do
#   user = User.new(
#     username: Faker::Name.first_name,
#     email: Faker::Internet.safe_email,
#     password: 'azerty',
#     description: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false),
#     hobbies: Faker::Hobby.activity, # BOB: to update when hobbies is changed from f.input to f.select
#     birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
#     birth_hour: "#{rand(0..23).to_s.rjust(2, '0')}:#{rand(0..59).to_s.rjust(2, '0')}",
#     birth_location: Faker::Address.city,
#     gender: rand(1..2),
#     looking_for: rand(1..2)
#   )
#   file = URI.open('https://thispersondoesnotexist.com/image')
#   user.photos.attach(io: file, filename: 'user.png', content_type: 'image/png')
#   user.save!
# end

puts 'Finished!'

puts 'Creating Chatroom...'



puts 'Finished!'

puts 'Creating Matches...'


puts 'Finished!'

puts 'Creating Messages...'

Message.new(
  content: "coucou!",
  chatroom_id: Chatroom.first.id,
  user_id: maria.id
).save!
Message.new(
  content: "yo!",
  chatroom_id: Chatroom.first.id,
  user_id: boris.id
).save!
Message.new(
  content: "ça va ?",
  chatroom_id: Chatroom.first.id,
  user_id: maria.id
).save!

puts 'Finished!'

# BOB :
# A garder sous le coude pour éventuellement remplacer les villes proposées par Faker (permet de coupler les villes avec leurs Etats et Pays)
# require 'city-state'
# random_country_key = CS.countries.to_a.sample.first
# random_state_key = CS.states(random_country_key).to_a.sample.first
# birth_location: "#{CS.cities(random_state_key, random_country_key).sample} (#{CS.states(random_country_key)[random_state_key]}, #{CS.countries[random_country_key]})",
