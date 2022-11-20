# <=== DATABASE CLEANOUT ===>

puts 'Cleaning database...'
User.destroy_all
Match.destroy_all
Chatroom.destroy_all
puts 'Database clean'

# <=== USERS SEEDING ===>

puts 'Creating users...'

# <-- Set users data --->

boris_bourdet_data = {
  username: 'Boris',
  email: 'boris_bourdet@hotmail.com',
  password: 'azerty',
  description: "Pendant longtemps j'ai alterné entre abdos et ventre qui pend.",
  birth_date: '26/06/1977',
  birth_hour: '05:30',
  birth_location: 'Aix-en-Provence',
  birth_country: 'FR',
  latitude: '43.529742',
  longitude: '5.447427',
  gender: 1,
  looking_for: 2,

}

etienne_de_dianous_data = {
  username: 'Etienne',
  email: 'etiennededi@hotmail.fr',
  password: 'azerty',
  description: "Si toi aussi tu aimes coder en peignoir, alors on est faits pour s'entendre.",
  birth_date: '23/06/1994',
  birth_hour: '06:30',
  birth_location: 'Paris',
  birth_country: 'FR',
  latitude: '48.856614',
  longitude: '2.3522219',
  gender: 1,
  looking_for: 2
}
ghita_aaddaj_data = {
  username: 'Ghita',
  email: 'aa.ghita@gmail.com',
  password: 'azerty',
  description: "Je suis de nature joyeuse, mais attention, j'ai le coup de boule facile quand on m'énerve.",
  birth_date: '23/07/1988',
  birth_hour: '07:30',
  birth_location: 'Casablanca',
  birth_country: 'MA',
  latitude: '33.5731104',
  longitude: '-7.5898434',
  gender: 2,
  looking_for: 1
}
maria_leonor_varela_borges_data = {
  username: 'Maria',
  email: 'leonor.varela91330@gmail.com',
  password: 'azerty',
  description: "Carlos Santana ne s'est jamais remis de notre séparation.",
  birth_date: '15/08/1993',
  birth_hour: '15:15',
  birth_location: 'Cascais',
  birth_country: 'PT',
  latitude: '38.6970565',
  longitude: '-9.4222945',
  gender: 2,
  looking_for: 1
}
mathieu_trancoso_data = {
  username: 'Mathieu',
  email: 'm.trancoso@astrocrush.io',
  password: 'azerty',
  description: "All you need is code.",
  birth_date: '21/01/1994',
  birth_hour: '16:00',
  birth_location: 'Ermont',
  birth_country: 'FR',
  latitude: '48.989071',
  longitude: '2.258451',
  gender: 1,
  looking_for: 2
}
laura_person_data = {
  username: 'Laura',
  email: 'l.person@astrocrush.io',
  password: 'azerty',
  description: "All you need is code.",
  birth_date: '13/12/1992',
  birth_hour: '11:00',
  birth_location: 'Landerneau',
  birth_country: 'FR',
  latitude: '48.450821',
  longitude: '-4.248437',
  gender: 2,
  looking_for: 1
}
alexandre_platteeuw_data = {
  username: 'Alex',
  email: 'a.platteeuw@astrocrush.io',
  password: 'azerty',
  description: "All you need is code.",
  birth_date: '11/10/1993',
  birth_hour: '10:30',
  birth_location: 'Roubaix',
  birth_country: 'FR',
  latitude: '50.6927049',
  longitude: '3.177847',
  gender: 1,
  looking_for: 2
}
kenza_tighrine_data = {
  username: 'Kenza',
  email: 'k.tighrine@astrocrush.io',
  password: 'azerty',
  description: "Certains m'appellent Karima, mais c'est pas grave.",
  birth_date: '04/08/1995',
  birth_hour: '10:45',
  birth_location: 'Paris',
  birth_country: 'FR',
  latitude: '48.856614',
  longitude: '2.3522219',
  gender: 2,
  looking_for: 1
}
bruno_lelay_data = {
  username: 'Bruno',
  email: 'b.lelay@astrocrush.io',
  password: 'azerty',
  description: "For those about to rock, I salute you.",
  birth_date: '15/01/1995',
  birth_hour: '23:40',
  birth_location: 'Longjumeau',
  birth_country: 'FR',
  latitude: '48.6930642',
  longitude: '2.2947615',
  gender: 1,
  looking_for: 2
}
sophiana_busso_data = {
  username: 'Sophiana',
  email: 's.busso@astrocrush.io',
  password: 'azerty',
  description: "Si vous aimez voyager dans le cosmos, nous devrions nous croiser.",
  birth_date: '24/02/1986',
  birth_hour: '02:35',
  birth_location: 'Paris',
  birth_country: 'FR',
  latitude: '48.856614',
  longitude: '2.3522219',
  gender: 2,
  looking_for: 1
}
ibrahima_kaba_data = {
  username: 'Ibrahima',
  email: 'i.kaba@astrocrush.io',
  password: 'azerty',
  description: "Tout ce dont vous avez besoin, c'est d'un bon front end et d'un voisin qui sait cuisiner.",
  birth_date: '23/12/1992',
  birth_hour: '05:30',
  birth_location: 'Conakry',
  birth_country: 'GN',
  latitude: '9.6411855',
  longitude: '-13.5784012',
  gender: 1,
  looking_for: 2
}
isabelle_levy_data = {
  username: 'Isabelle',
  email: 'i.levy@astrocrush.io',
  password: 'azerty',
  description: "Ne le dîtes pas à mon fils.",
  birth_date: '01/01/1963',
  birth_hour: '07:00',
  birth_location: 'Compiegne',
  birth_country: 'FR',
  latitude: '49.417816',
  longitude: '2.826145',
  gender: 2,
  looking_for: 1
}
corentin_deseine_data = {
  username: 'Corentin',
  email: 'c.deseine@astrocrush.io',
  password: 'azerty',
  description: "Mon nombre préféré ? Le 15 !",
  birth_date: '02/08/1996',
  birth_hour: '11:30',
  birth_location: 'Ermont',
  birth_country: 'FR',
  latitude: '48.989071',
  longitude: '2.258451',
  gender: 1,
  looking_for: 2
}
aicha_diagne_data = {
  username: 'Aicha',
  email: 'a.diagne@astrocrush.io',
  password: 'azerty',
  description: "Avec moi, votre produit est entre de bonnes mains.",
  birth_date: '31/05/1996',
  birth_hour: '13:00',
  birth_location: 'Dakar',
  birth_country: 'SN',
  latitude: '14.716677',
  longitude: '-17.4676861',
  gender: 2,
  looking_for: 1
}
paul_portier_data = {
  username: 'Paul',
  email: 'p.portier@astrocrush.io',
  password: 'azerty',
  description: "Je ne crois pas à l'astrologie, mais je ne peux pas non plus démontrer qu'elle ne fonctionne pas...",
  birth_date: '28/12/1991',
  birth_hour: '11:30',
  birth_location: 'Boulogne-Billancourt',
  birth_country: 'FR',
  latitude: '48.8396952',
  longitude: '2.2399123',
  gender: 1,
  looking_for: 2
}
nadia_auger_data = {
  username: 'Nadia',
  email: 'n.auger@astrocrush.io',
  password: 'azerty',
  description: "Code rime avec mode !",
  birth_date: '23/08/1993',
  birth_hour: '09:45',
  birth_location: 'Bordeaux',
  birth_country: 'FR',
  latitude: '44.837789',
  longitude: '-0.57918',
  gender: 2,
  looking_for: 1
}
jeremy_barbedienne_data = {
  username: 'Jeremy',
  email: 'j.barbedienne@astrocrush.io',
  password: 'azerty',
  description: "N'oubliez pas de signer la feuille de présence !",
  birth_date: '20/09/1993',
  birth_hour: '10:30',
  birth_location: 'Saint-Lo',
  birth_country: 'FR',
  latitude: '49.1154686',
  longitude: '-1.0828136',
  gender: 1,
  looking_for: 2
}
charlotte_bory_data = {
  username: 'Charlotte',
  email: 'c.bory@astrocrush.io',
  password: 'azerty',
  description: "Du code au tricot, il n'y a qu'une ligne !",
  birth_date: '25/02/1994',
  birth_hour: '02:24',
  birth_location: 'Paris',
  birth_country: 'FR',
  latitude: '48.856614',
  longitude: '2.3522219',
  gender: 2,
  looking_for: 1
}
marine_sourin_data = {
  username: 'Marine',
  email: 'm.sourin@astrocrush.io',
  password: 'azerty',
  description: "Cela ne me fait pas peur de passer 2h en ticket pour vous sortir de la m....",
  birth_date: '07/05/1995',
  birth_hour: '06:20',
  birth_location: 'La Garenne-Colombes',
  birth_country: 'FR',
  latitude: '48.906535',
  longitude: '2.244085',
  gender: 2,
  looking_for: 1
}
boris_paillard_data = {
  username: 'Papillard',
  email: 'b.paillard@astrocrush.io',
  password: 'azerty',
  description: "Change your life, subscribe to astrocrush.",
  birth_date: '06/11/1985',
  birth_hour: '23:00',
  birth_location: 'Conflans-Sainte-Honorine',
  birth_country: 'FR',
  latitude: '49.000275',
  longitude: '2.09178',
  gender: 1,
  looking_for: 2
}
claire_ziemendorf_data = {
  username: 'Claire',
  email: 'c.ziemendorf@astrocrush.io',
  password: 'azerty',
  description: "All you need is code..",
  birth_date: '16/05/1994',
  birth_hour: '23:58',
  birth_location: 'Rueil-Malmaison',
  birth_country: 'FR',
  latitude: '48.882767',
  longitude: '2.17693',
  gender: 2,
  looking_for: 1
}
zoe_kravitz_data = {
  username: 'Zoe',
  email: 'z.kravitz@astrocrush.io',
  password: 'azerty',
  description: "Miaou!",
  birth_date: '01/12/1988',
  birth_hour: '02:00',
  birth_location: 'Los Angeles',
  birth_country: 'US',
  latitude: '34.0522342',
  longitude: '-118.2436849',
  gender: 2,
  looking_for: 1
}

users_data = [
  boris_bourdet_data,
  etienne_de_dianous_data,
  ghita_aaddaj_data,
  maria_leonor_varela_borges_data,
  mathieu_trancoso_data,
  laura_person_data,
  alexandre_platteeuw_data,
  kenza_tighrine_data,
  bruno_lelay_data,
  sophiana_busso_data,
  ibrahima_kaba_data,
  isabelle_levy_data,
  corentin_deseine_data,
  aicha_diagne_data,
  paul_portier_data,
  nadia_auger_data,
  jeremy_barbedienne_data,
  charlotte_bory_data,
  marine_sourin_data,
  boris_paillard_data,
  claire_ziemendorf_data
  # zoe_kravitz_data
]

# <--- Set Photos --->

photos_boris_bourdet = [
  File.open(Rails.root.join("public/seed_images/boris_1.jpg")),
  File.open(Rails.root.join("public/seed_images/boris_2.jpg")),
  File.open(Rails.root.join("public/seed_images/boris_3.jpg"))
]
photos_etienne_de_dianous = [
  File.open(Rails.root.join("public/seed_images/etienne_1.jpg")),
  File.open(Rails.root.join("public/seed_images/etienne_2.jpg")),
  File.open(Rails.root.join("public/seed_images/etienne_1.jpg"))
]
photos_ghita_aaddaj = [
  File.open(Rails.root.join("public/seed_images/ghita_1.jpg")),
  File.open(Rails.root.join("public/seed_images/ghita_2.jpg")),
  File.open(Rails.root.join("public/seed_images/ghita_3.jpg"))
]
photos_maria_leonor_varela_borges = [
  File.open(Rails.root.join("public/seed_images/maria_1.jpg")),
  File.open(Rails.root.join("public/seed_images/maria_2.jpg")),
  File.open(Rails.root.join("public/seed_images/maria_3.jpg"))
]
photos_mathieu_trancoso = [
  File.open(Rails.root.join("public/seed_images/mathieu_trancoso.jpg")),
  File.open(Rails.root.join("public/seed_images/mathieu_trancoso.jpg")),
  File.open(Rails.root.join("public/seed_images/mathieu_trancoso.jpg"))
]
photos_laura_person = [
  File.open(Rails.root.join("public/seed_images/laura_person.jpg")),
  File.open(Rails.root.join("public/seed_images/laura_person.jpg")),
  File.open(Rails.root.join("public/seed_images/laura_person.jpg"))
]
photos_alexandre_platteeuw = [
  File.open(Rails.root.join("public/seed_images/alexandre_platteeuw.jpg")),
  File.open(Rails.root.join("public/seed_images/alexandre_platteeuw.jpg")),
  File.open(Rails.root.join("public/seed_images/alexandre_platteeuw.jpg"))
]
photos_kenza_tighrine = [
  File.open(Rails.root.join("public/seed_images/kenza_tighrine_1.jpg")),
  File.open(Rails.root.join("public/seed_images/kenza_tighrine_2.jpg")),
  File.open(Rails.root.join("public/seed_images/kenza_tighrine_1.jpg"))
]
photos_bruno_lelay = [
  File.open(Rails.root.join("public/seed_images/bruno_lelay.jpg")),
  File.open(Rails.root.join("public/seed_images/bruno_lelay.jpg")),
  File.open(Rails.root.join("public/seed_images/bruno_lelay.jpg"))
]
photos_sophiana_busso = [
  File.open(Rails.root.join("public/seed_images/sophiana_busso.jpg")),
  File.open(Rails.root.join("public/seed_images/sophiana_busso.jpg")),
  File.open(Rails.root.join("public/seed_images/sophiana_busso.jpg"))
]
photos_ibrahima_kaba = [
  File.open(Rails.root.join("public/seed_images/ibrahima_kaba_1.jpg")),
  File.open(Rails.root.join("public/seed_images/ibrahima_kaba_2.jpg")),
  File.open(Rails.root.join("public/seed_images/ibrahima_kaba_1.jpg"))
]
photos_isabelle_levy = [
  File.open(Rails.root.join("public/seed_images/isabelle_levy_1.jpg")),
  File.open(Rails.root.join("public/seed_images/isabelle_levy_2.jpg")),
  File.open(Rails.root.join("public/seed_images/isabelle_levy_1.jpg"))
]
photos_corentin_deseine = [
  File.open(Rails.root.join("public/seed_images/corentin_deseine_1.jpg")),
  File.open(Rails.root.join("public/seed_images/corentin_deseine_2.jpg")),
  File.open(Rails.root.join("public/seed_images/corentin_deseine_1.jpg"))
]
photos_aicha_diagne = [
  File.open(Rails.root.join("public/seed_images/aicha_diagne.jpg")),
  File.open(Rails.root.join("public/seed_images/aicha_diagne.jpg")),
  File.open(Rails.root.join("public/seed_images/aicha_diagne.jpg"))
]
photos_paul_portier = [
  File.open(Rails.root.join("public/seed_images/paul_portier_1.jpg")),
  File.open(Rails.root.join("public/seed_images/paul_portier_2.jpg")),
  File.open(Rails.root.join("public/seed_images/paul_portier_1.jpg"))
]
photos_nadia_auger = [
  File.open(Rails.root.join("public/seed_images/nadia_auger_1.jpg")),
  File.open(Rails.root.join("public/seed_images/nadia_auger_2.jpg")),
  File.open(Rails.root.join("public/seed_images/nadia_auger_3.jpg"))
]
photos_jeremy_barbedienne = [
  File.open(Rails.root.join("public/seed_images/jeremy_barbedienne_1.jpg")),
  File.open(Rails.root.join("public/seed_images/jeremy_barbedienne_2.jpg")),
  File.open(Rails.root.join("public/seed_images/jeremy_barbedienne_1.jpg"))
]
photos_charlotte_bory = [
  File.open(Rails.root.join("public/seed_images/charlotte_bory_1.jpg")),
  File.open(Rails.root.join("public/seed_images/charlotte_bory_2.jpg")),
  File.open(Rails.root.join("public/seed_images/charlotte_bory_1.jpg"))
]
photos_marine_sourin = [
  File.open(Rails.root.join("public/seed_images/marine_sourin_1.jpg")),
  File.open(Rails.root.join("public/seed_images/marine_sourin_2.jpg")),
  File.open(Rails.root.join("public/seed_images/marine_sourin_1.jpg"))
]
photos_boris_paillard = [
  File.open(Rails.root.join("public/seed_images/boris_paillard_1.jpg")),
  File.open(Rails.root.join("public/seed_images/boris_paillard_2.jpg")),
  File.open(Rails.root.join("public/seed_images/boris_paillard_3.jpg"))
]
photos_claire_ziemendorf = [
  File.open(Rails.root.join("public/seed_images/claire_ziemendorf_1.jpg")),
  File.open(Rails.root.join("public/seed_images/claire_ziemendorf_1.jpg")),
  File.open(Rails.root.join("public/seed_images/claire_ziemendorf_1.jpg"))
]
photos_zoe_kravitz = [
  File.open(Rails.root.join("public/seed_images/zoe_kravitz.jpg")),
  File.open(Rails.root.join("public/seed_images/zoe_kravitz.jpg")),
  File.open(Rails.root.join("public/seed_images/zoe_kravitz.jpg"))
]

users_photos = [
  photos_boris_bourdet,
  photos_etienne_de_dianous,

  photos_ghita_aaddaj,
  photos_maria_leonor_varela_borges,
  photos_mathieu_trancoso,
  photos_laura_person,
  photos_alexandre_platteeuw,
  photos_kenza_tighrine,
  photos_bruno_lelay,
  photos_sophiana_busso,
  photos_ibrahima_kaba,
  photos_isabelle_levy,
  photos_corentin_deseine,
  photos_aicha_diagne,
  photos_paul_portier,
  photos_nadia_auger,
  photos_jeremy_barbedienne,
  photos_charlotte_bory,
  photos_marine_sourin,
  photos_boris_paillard,
  photos_claire_ziemendorf
  # photos_zoe_kravitz
]

# <--- Create Users --->
# if User.all.blank?
  users_data.each_with_index do |user_data, index|
    user = User.new(user_data)


    user.horoscope_data = AstrologyApi.new.horoscope(user.birth_date, user.birth_hour, user.latitude, user.longitude)
    user.sign = user.horoscope_data['planets'].first['sign']
    user.rising = user.horoscope_data['houses'].first['sign']
    user.moon = user.horoscope_data['planets'][1]['sign']
    user.wheel_chart = AstrologyApi.new.wheel_chart(user.birth_date, user.birth_hour, user.latitude, user.longitude, "#2E3A59", "#ffffff", "#ffffff", "#2E3A59")
    user.timezone = AstrologyApi.new.time_zone(user.latitude, user.longitude, user.birth_date)
    users_photos[index].each { |photo| user.photos.attach(io: photo, filename: user.username, content_type: 'jpg') }
    user.save!
    p "*** #{user.username} ***"
  end

# <--- Calculate and attach affinity scores and reports --->

  users = User.all

  users.each do |user|
    potential_mates = User.where(gender: user.looking_for).where.not(id: user.id)
    score_collection = {}
    partner_report_collection = {}
    potential_mates.each do |mate|
      if mate.gender == 2
        mate_score = AstrologyApi.new.match_percentage(
          user.birth_date,
          user.birth_hour,
          user.latitude,
          user.longitude,
          mate.birth_date,
          mate.birth_hour,
          mate.latitude,
          mate.longitude
        )
      else
        mate_score = AstrologyApi.new.match_percentage(
          mate.birth_date,
          mate.birth_hour,
          mate.latitude,
          mate.longitude,
          user.birth_date,
          user.birth_hour,
          user.latitude,
          user.longitude
        )
      end
      score_collection.store(mate.id, mate_score)

      mate_partner_report = AstrologyApi.new.partner_report(
        user.birth_date,
        user.gender,
        mate.birth_date,
        mate.gender,
        mate.username
      )
      partner_report_collection.store(mate.id, mate_partner_report)
    end
    ordered_score_collection = score_collection.sort_by { |_id, score| score }
    user.affinity_scores = ordered_score_collection.reverse.to_h
    user.partner_reports = partner_report_collection
    puts "*** #{user.username} complementary attachments ok ***"
    user.save!
  end

  # <=== SKIP CONFIRMATION ===>

  users = User.all
  users.each do |user|
    user.confirm
    user.save!
  end

  puts "all confirmations skiped"
# end

# Adding fictive ip address

User.all.each do |user|
  user.search_perimeter = 20000
  user.last_sign_in_ip = Faker::Internet.ip_v4_address
  data = Geocoder.search(user.last_sign_in_ip.to_s).first.coordinates
  p "here is data before it's in the until loop (or not): #{data}"
  until data != []
    user.last_sign_in_ip = Faker::Internet.ip_v4_address
    user.save
    p "here is a new ip for #{user.email}, #{user.last_sign_in_ip}"
    data = Geocoder.search(user.last_sign_in_ip.to_s).first.coordinates
    p data
  end
  p "congrats, data is not []"
  user.save!
  p 'one user saved!'
end

# <-- SEED POUR TESTER SIDEKIQ -->
# users_data.each_with_index do |user_data, index|
#   p 'aller letsgo'
#   user = User.new(user_data)
#   Astroprofil.profil(user)
#   users_photos[index].each do |photo|
#     p 'attaching photo'
#     user.photos.attach(io: photo, filename: user.username, content_type: 'jpg')
#     user.save!
#     p 'user saved'
#   end
# end
# <!-- FIN DE LA SEED SIDEKIQ -->


# <--- Calculate and attach affinity scores and reports --->
# ùù
# users = User.all

# users.each do |user|
#   potential_mates = User.where(gender: user.looking_for).where.not(id: user.id)
#   score_collection = {}
#   partner_report_collection = {}
#   sun_report_collection = {}
#   potential_mates.each do |mate|
#     if mate.gender == 2
#       mate_score = API_CALL.match_percentage(
#         user.birth_date,
#         user.birth_hour,
#         user.latitude,
#         user.longitude,
#         mate.birth_date,
#         mate.birth_hour,
#         mate.latitude,
#         mate.longitude
#       )
#       score_collection.store(mate.id, mate_score)
#     else
#       mate_score = API_CALL.match_percentage(
#         mate.birth_date,
#         mate.birth_hour,
#         mate.latitude,
#         mate.longitude,
#         user.birth_date,
#         user.birth_hour,
#         user.latitude,
#         user.longitude
#       )
#       score_collection.store(mate.id, mate_score)
#     end

#     mate_partner_report = API_CALL.partner_report(
#       user.birth_date,
#       user.gender,
#       mate.birth_date,
#       mate.gender,
#       mate.username
#     )
#     partner_report_collection.store(mate.id, mate_partner_report)

#     mate_sun_report = API_CALL.sign_report(
#       mate.birth_date,
#       mate.birth_hour,
#       mate.latitude,
#       mate.longitude,
#       'sun'
#     )
#     sun_report_collection.store(mate.id, mate_sun_report)
#   end
#   ordered_score_collection = score_collection.sort_by { |_id, score| score }
#   user.affinity_scores = ordered_score_collection.reverse.to_h
#   user.partner_reports = partner_report_collection
#   user.mate_sun_reports = sun_report_collection
#   puts "*** #{user.username} complementary attachments ok ***"
#   user.save!
# end

# puts "#{User.all.length} users created successfully!"

# <=== USER INTEREST ===>

if Interest.all.blank?
  puts "Creating interests"
  interests = [
    { name: 'American football',
      emoji: '🏈' },
    { name: 'Animals',
      emoji: '😸' },
    { name: 'Art and Culture',
      emoji: '🎭' },
    { name: 'Automotive',
      emoji: '🚘' },
    { name: 'Baseball',
      emoji: '⚾' },
    { name: 'Basketball',
      emoji: '🏀' },
    { name: 'Blockchain',
      emoji: '🖥️' },
    { name: 'Board games',
      emoji: '🎲' },
    { name: 'Brunch',
      emoji: '🍳' },
    { name: 'Business',
      emoji: '👔' },
    { name: 'Collector',
      emoji: '⌚' },
    { name: 'Concert Festival',
      emoji: '🎤' },
    { name: 'Cooking',
      emoji: '🍽️' },
    { name: 'Cryptocurrency',
      emoji: '₿' },
    { name: 'Ecology',
      emoji: '🌳' },
    { name: 'Extreme sport',
      emoji: '🪂' },
    { name: 'Fashion',
      emoji: '👠' },
    { name: 'Feminism',
      emoji: '♀️' },
    { name: 'Football',
      emoji: '⚽' },
    { name: 'Gambling',
      emoji: '🎰' },
    { name: 'Gaming',
      emoji: '🎮' },
    { name: 'Gastronomy',
      emoji: '👨‍🍳' },
    { name: 'Graphic arts',
      emoji: '🎨' },
    { name: 'Investments',
      emoji: '🤑' },
    { name: 'Jet set',
      emoji: '🍸' },
    { name: 'LGBT',
      emoji: '🌈' },
    { name: 'Lifestyle',
      emoji: '⏰' },
    { name: 'Manga',
      emoji: '🍥' },
    { name: 'Meet',
      emoji: '🤝🏼' },
    { name: 'Metaverse',
      emoji: '🗺️' },
    { name: 'Motor sports',
      emoji: '🏎️' },
    { name: 'Movies and series',
      emoji: '🎞️' },
    { name: 'Music',
      emoji: '🎵' },
    { name: 'Nightlife',
      emoji: '🌃' },
    { name: 'Oenology',
      emoji: '🍷' },
    { name: 'Rap FR',
      emoji: '⛓️' },
    { name: 'Rap US',
      emoji: '🧢' },
    { name: 'Reggae',
      emoji: '🦁' },
    { name: 'Rock',
      emoji: '🎸' },
    { name: 'Rocket School',
      emoji: '👨‍🚀' },
    { name: 'Scolar',
      emoji: '🎓' },
    { name: 'Senior',
      emoji: '👵' },
    { name: 'Sexuality',
      emoji: '😈' },
    { name: 'Skateboard',
      emoji: '🛹' },
    { name: 'Social Activity',
      emoji: '🤚' },
    { name: 'Social movement',
      emoji: '📣' },
    { name: 'Spirituality',
      emoji: '🙏' },
    { name: 'Sport',
      emoji: '🏅' },
    { name: 'Startup World',
      emoji: '🦄' },
    { name: 'Techno',
      emoji: '💿' },
    { name: 'Trading Card Games',
      emoji: '🗂️' },
    { name: 'Travel',
      emoji: '✈️' }
  ]

  # <--- Create Interests --->

  interests.each do |interest|
    puts "create #{interest[:name]}"
    Interest.create({ name: interest[:name], emoji: interest[:emoji] })
  end
end

puts "#{Interest.all.length} interests created successfully!"
