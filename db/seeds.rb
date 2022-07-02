require 'open-uri'
require 'faker'
require_relative '../app/services/astrology_api'
require 'resolv-replace'

api_uid = ENV["API_UID"]
api_key = ENV["API_KEY"]

# <=== DATABASE CLEANOUT ===>

puts 'Cleaning database...'
User.destroy_all
Match.destroy_all
Chatroom.destroy_all
puts 'Database clean'

# <=== USERS SEEDING ===>

puts 'Creating users...'

# <-- Set Team users data --->

boris_data = {
  username: 'Boris',
  email: 'boris_bourdet@hotmail.com',
  password: 'azerty',
  description: "I know a good Thai restaurant in rue Oberkampf.",
  hobbies: ['Chamber music', 'Astrology'],
  birth_date: '26/06/1977',
  birth_hour: '05:30',
  birth_location: 'Aix-en-Provence',
  birth_country: 'FR',
  gender: 1,
  looking_for: 2
}
etienne_data = {
  username: 'Etienne',
  email: 'etiennededi@hotmail.fr',
  password: 'azerty',
  description: "If you too like to code in bathrobe, we are made to be together.",
  hobbies: ['Diabolo', 'Bolas', 'Fire-eating', 'Permaculture'],
  birth_date: '23/06/1994',
  birth_hour: '06:30',
  birth_location: 'Paris',
  birth_country: 'FR',
  gender: 1,
  looking_for: 2
}
ghita_data = {
  username: 'Ghita',
  email: 'aa.ghita@gmail.com',
  password: 'azerty',
  description: "I am a cool one, but careful, I can head-butt if someone pisses me off.",
  hobbies: ['Teuf de meufs', 'Micro-nations', 'Mobylettes', 'ZAD'],
  birth_date: '23/07/1988',
  birth_hour: '07:30',
  birth_location: 'Casablanca',
  birth_country: 'MA',
  gender: 2,
  looking_for: 1
}
maria_data = {
  username: 'Maria',
  email: 'leonor.varela91330@gmail.com',
  password: 'azerty',
  description: "Carlos Santana never recovered from our separation.",
  hobbies: ['Travel', 'Theater', 'Knitting', 'Paintball'],
  birth_date: '15/08/1993',
  birth_hour: '15:15',
  birth_location: 'Cascais',
  birth_country: 'PT',
  gender: 2,
  looking_for: 1
}

team_users_data = [
  boris_data,
  etienne_data,
  ghita_data,
  maria_data
]

# <-- Set Wagon users data --->

mathieu_trancoso_data = {
  username: 'Mathieu',
  email: 'm.trancoso@astrocrush.io',
  password: 'azerty',
  description: "All you need is code.",
  hobbies: ['Wagonner'],
  birth_date: '21/01/1994',
  birth_hour: '16:00',
  birth_location: 'Ermont',
  birth_country: 'FR',
  gender: 1,
  looking_for: 2
}
laura_person_data = {
  username: 'Laura',
  email: 'l.person@astrocrush.io',
  password: 'azerty',
  description: "All you need is code.",
  hobbies: ['Wagonner'],
  birth_date: '13/12/1992',
  birth_hour: '11:00',
  birth_location: 'Landerneau',
  birth_country: 'FR',
  gender: 2,
  looking_for: 1
}
alexandre_platteeuw_data = {
  username: 'Alex',
  email: 'a.platteeuw@astrocrush.io',
  password: 'azerty',
  description: "All you need is code.",
  hobbies: ['Wagonner'],
  birth_date: '11/10/1993',
  birth_hour: '10:30',
  birth_location: 'Roubaix',
  birth_country: 'FR',
  gender: 1,
  looking_for: 2
}
kenza_tighrine_data = {
  username: 'Kenza',
  email: 'k.tighrine@astrocrush.io',
  password: 'azerty',
  description: "Sometimes they call me Karima, but it doesn't matter.",
  hobbies: ['Chicha', 'Djellaba'],
  birth_date: '04/08/1995',
  birth_hour: '10:45',
  birth_location: 'Paris',
  birth_country: 'FR',
  gender: 2,
  looking_for: 1
}
bruno_lelay_data = {
  username: 'Bruno',
  email: 'b.lelay@astrocrush.io',
  password: 'azerty',
  description: "For those about to rock, I salute you.",
  hobbies: ['Death metal', 'Drums'],
  birth_date: '15/01/1995',
  birth_hour: '23:40',
  birth_location: 'Longjumeau',
  birth_country: 'FR',
  gender: 1,
  looking_for: 2
}
sophiana_b_data = {
  username: 'Sophiana',
  email: 's.b@astrocrush.io',
  password: 'azerty',
  description: "If you like space travelling, we might meet.",
  hobbies: ['Drawing', 'Long distance trips'],
  birth_date: '24/02/1986',
  birth_hour: '02:35',
  birth_location: 'Paris',
  birth_country: 'FR',
  gender: 2,
  looking_for: 1
}
ibrahima_kaba_data = {
  username: 'Ibrahima',
  email: 'i.kaba@astrocrush.io',
  password: 'azerty',
  description: "All you need is a good css and a neighbor who cooks well.",
  hobbies: ['Css', 'Bicycle', 'Neighborfood'],
  birth_date: '23/12/1992',
  birth_hour: '05:30',
  birth_location: 'Conakry',
  birth_country: 'GN',
  gender: 1,
  looking_for: 2
}
isabelle_levy_data = {
  username: 'Isabelle',
  email: 'i.levy@astrocrush.io',
  password: 'azerty',
  description: "Don't tell my son.",
  hobbies: ['Travel'],
  birth_date: '01/01/1963',
  birth_hour: '07:00',
  birth_location: 'Compiegne',
  birth_country: 'FR',
  gender: 2,
  looking_for: 1
}
corentin_deseine_data = {
  username: 'Corentin',
  email: 'c.deseine@astrocrush.io',
  password: 'azerty',
  description: "If I had to choose a number between 1 and 100, it would probably be 15.",
  hobbies: ['Rugby', 'Gaming', 'Pokemons'],
  birth_date: '02/08/1996',
  birth_hour: '11:30',
  birth_location: 'Ermont',
  birth_country: 'FR',
  gender: 1,
  looking_for: 2
}
aicha_diagne_data = {
  username: 'Aicha',
  email: 'a.diagne@astrocrush.io',
  password: 'azerty',
  description: "Your product is in good hands.",
  hobbies: ['Luggage'],
  birth_date: '31/05/1996',
  birth_hour: '13:00',
  birth_location: 'Dakar',
  birth_country: 'SN',
  gender: 2,
  looking_for: 1
}
paul_portier_data = {
  username: 'Paul',
  email: 'p.portier@astrocrush.io',
  password: 'azerty',
  description: "I don't believe in astrology, but I can't prove it wrong either...",
  hobbies: ['Code', 'Photo'],
  birth_date: '28/12/1991',
  birth_hour: '11:30',
  birth_location: 'Boulogne-Billancourt',
  birth_country: 'FR',
  gender: 1,
  looking_for: 2
}
nadia_auger_data = {
  username: 'Nadia',
  email: 'n.auger@astrocrush.io',
  password: 'azerty',
  description: "Who said geeks can't be fashionable?",
  hobbies: ['Code', 'Fashion', 'Chihuahuas'],
  birth_date: '23/08/1993',
  birth_hour: '09:45',
  birth_location: 'Bordeaux',
  birth_country: 'FR',
  gender: 2,
  looking_for: 1
}
jeremy_barbedienne_data = {
  username: 'Jeremy',
  email: 'j.barbedienne@astrocrush.io',
  password: 'azerty',
  description: "Don't forget to sign the attendance sheet.",
  hobbies: ['Code', 'Cooking', 'Booze'],
  birth_date: '20/09/1993',
  birth_hour: '10:30',
  birth_location: 'Saint-Lo',
  birth_country: 'FR',
  gender: 1,
  looking_for: 2
}
charlotte_bory_data = {
  username: 'Charlotte',
  email: 'c.bory@astrocrush.io',
  password: 'azerty',
  description: "Lines of code and lines of knitting, all the same to me.",
  hobbies: ['Code', 'Knitting', 'Roller coaster'],
  birth_date: '25/02/1994',
  birth_hour: '02:24',
  birth_location: 'Paris',
  birth_country: 'FR',
  gender: 2,
  looking_for: 1
}
marine_sourin_data = {
  username: 'Marine',
  email: 'm.sourin@astrocrush.io',
  password: 'azerty',
  description: "I'm not afraid by a 2 hours ticket to get you out of shit.",
  hobbies: ['Coding'],
  birth_date: '07/05/1995',
  birth_hour: '06:20',
  birth_location: 'La Garenne-Colombes',
  birth_country: 'FR',
  gender: 2,
  looking_for: 1
}
boris_paillard_data = {
  username: 'Papillard',
  email: 'b.paillard@astrocrush.io',
  password: 'azerty',
  description: "Change your life, subscribe to astrocrush.",
  hobbies: ['Worldwide code', 'Beatles', 'Motorcycles'],
  birth_date: '06/11/1985',
  birth_hour: '23:00',
  birth_location: 'Conflans-Sainte-Honorine',
  birth_country: 'FR',
  gender: 1,
  looking_for: 2
}

wagon_users_data = [
  mathieu_trancoso_data,
  laura_person_data,
  alexandre_platteeuw_data,
  kenza_tighrine_data,
  bruno_lelay_data,
  sophiana_b_data,
  ibrahima_kaba_data,
  isabelle_levy_data,
  corentin_deseine_data,
  aicha_diagne_data,
  paul_portier_data,
  nadia_auger_data,
  jeremy_barbedienne_data,
  charlotte_bory_data,
  marine_sourin_data,
  boris_paillard_data
]

# <--- Set famous users data --->

# juliette_armanet_data = {
#   username: 'Juliette',
#   email: 'j.armanet@astrocrush.io',
#   password: 'azerty',
#   description: "D’abord comédienne, puis documentariste, à 30 ans passés, je me suis lancée dans la chanson, avec Michel Berger et Véronique Sanson pour modèles.",
#   hobbies: ['Music', 'Singing'],
#   birth_date: '04/03/1984',
#   birth_hour: '21:20',
#   birth_location: 'Lille',
#   birth_country: 'FR',
#   gender: 2,
#   looking_for: 1
# }
# melanie_thierry_data = {
#   username: 'Melanie',
#   email: 'm.thierry@astrocrush.io',
#   password: 'azerty',
#   description: "J'adore qu'on me dise que je suis drôle.",
#   hobbies: ['Cinema', 'Music', 'Series'],
#   birth_date: '17/07/1981',
#   birth_hour: '03:30',
#   birth_location: 'Saint-Germain-en-Laye',
#   birth_country: 'FR',
#   gender: 2,
#   looking_for: 1
# }
# emma_mackey_data = {
#   username: 'Emma',
#   email: 'e.mackey@astrocrush.io',
#   password: 'azerty',
#   description: "Fuck of snowflake.",
#   hobbies: ['Cinema', 'Netflix'],
#   birth_date: '04/01/1996',
#   birth_hour: '14:42',
#   birth_location: 'Le Mans',
#   birth_country: 'FR',
#   gender: 2,
#   looking_for: 1
# }
zoe_kravitz_data = {
  username: 'Zoe',
  email: 'z.kravitz@astrocrush.io',
  password: 'azerty',
  description: "Miaou!",
  hobbies: ['Cinema', 'Perfume', 'Cats'],
  birth_date: '01/12/1988',
  birth_hour: '02:00',
  birth_location: 'Los Angeles',
  birth_country: 'US',
  gender: 2,
  looking_for: 1
}
# natalie_portman_data = {
#   username: 'Natalie',
#   email: 'n.portman@astrocrush.io',
#   password: 'azerty',
#   description: "Que la force soit avec vous...",
#   hobbies: ['Cinema', 'Politics', 'Danse'],
#   birth_date: '09/06/1981',
#   birth_hour: '15:42',
#   birth_location: 'Jerusalem',
#   birth_country: 'IL',
#   gender: 2,
#   looking_for: 1
# }
# tom_leeb_data = {
#   username: 'Tom',
#   email: 't.leeb@astrocrush.io',
#   password: 'azerty',
#   description: "La TV me réussit mieux que la chanson.",
#   hobbies: ['TV', 'Singing'],
#   birth_date: '21/03/1990',
#   birth_hour: '17:07',
#   birth_location: 'Paris',
#   birth_country: 'FR',
#   gender: 1,
#   looking_for: 2
# }
# pierre_niney_data = {
#   username: 'Pierre',
#   email: 'p.niney@astrocrush.io',
#   password: 'azerty',
#   description: "Le Docteur Juiphe est un cousin éloigné.",
#   hobbies: ['Cinema'],
#   birth_date: '13/03/1989',
#   birth_hour: '03:20',
#   birth_location: 'Boulogne-Billancourt',
#   birth_country: 'FR',
#   gender: 1,
#   looking_for: 2
# }
# pio_marmai_data = {
#   username: 'Pio',
#   email: 'p.marmai@astrocrush.io',
#   password: 'azerty',
#   description: "J'ai longtemps alterné abdos et bide qui pend.",
#   hobbies: ['Cinema'],
#   birth_date: '13/07/1984',
#   birth_hour: '10:25',
#   birth_location: 'Strasbourg',
#   birth_country: 'FR',
#   gender: 1,
#   looking_for: 2
# }
# robert_pattinson_data = {
#   username: 'Robert',
#   email: 'r.pattinson@astrocrush.io',
#   password: 'azerty',
#   description: "Un bloody mary?",
#   hobbies: ['Cinema'],
#   birth_date: '13/05/1986',
#   birth_hour: '05:00',
#   birth_location: 'London',
#   birth_country: 'GB',
#   gender: 1,
#   looking_for: 2
# }
# rege_jean_page_data = {
#   username: 'Rege-Jean',
#   email: 'rj.page@astrocrush.io',
#   password: 'azerty',
#   description: "Mon nom est Bond?",
#   hobbies: ['Cinema', 'Netflix'],
#   birth_date: '27/04/1988',
#   birth_hour: '12:00',
#   birth_location: 'London',
#   birth_country: 'GB',
#   gender: 1,
#   looking_for: 2
# }

famous_users_data = [
#   juliette_armanet_data,
#   melanie_thierry_data,
#   emma_mackey_data,
  zoe_kravitz_data
#   natalie_portman_data,
#   tom_leeb_data,
#   pierre_niney_data,
#   pio_marmai_data,
#   robert_pattinson_data,
#   rege_jean_page_data
]

# <--- Set Photos --->

photos_boris = [
  File.open(Rails.root.join("public/seed_images/boris_1.jpg")),
  File.open(Rails.root.join("public/seed_images/boris_2.jpg")),
  File.open(Rails.root.join("public/seed_images/boris_3.jpg"))
]
photos_etienne = [
  File.open(Rails.root.join("public/seed_images/etienne_1.jpg")),
  File.open(Rails.root.join("public/seed_images/etienne_2.jpg")),
  File.open(Rails.root.join("public/seed_images/etienne_1.jpg"))
]
photos_ghita = [
  File.open(Rails.root.join("public/seed_images/ghita_1.jpg")),
  File.open(Rails.root.join("public/seed_images/ghita_2.jpg")),
  File.open(Rails.root.join("public/seed_images/ghita_3.jpg"))
]
photos_maria = [
  File.open(Rails.root.join("public/seed_images/maria_1.jpg")),
  File.open(Rails.root.join("public/seed_images/maria_2.jpg")),
  File.open(Rails.root.join("public/seed_images/maria_3.jpg"))
]

team_users_photos = [
  photos_boris,
  photos_etienne,
  photos_ghita,
  photos_maria
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
photos_sophiana_b = [
  File.open(Rails.root.join("public/seed_images/sophiana_b.jpg")),
  File.open(Rails.root.join("public/seed_images/sophiana_b.jpg")),
  File.open(Rails.root.join("public/seed_images/sophiana_b.jpg"))
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

wagon_users_photos = [
  photos_mathieu_trancoso,
  photos_laura_person,
  photos_alexandre_platteeuw,
  photos_kenza_tighrine,
  photos_bruno_lelay,
  photos_sophiana_b,
  photos_ibrahima_kaba,
  photos_isabelle_levy,
  photos_corentin_deseine,
  photos_aicha_diagne,
  photos_paul_portier,
  photos_nadia_auger,
  photos_jeremy_barbedienne,
  photos_charlotte_bory,
  photos_marine_sourin,
  photos_boris_paillard
]

# # photos_juliette_armanet = [
#   File.open(Rails.root.join("public/seed_images/juliette_armanet.jpg")),
#   File.open(Rails.root.join("public/seed_images/juliette_armanet.jpg")),
#   File.open(Rails.root.join("public/seed_images/juliette_armanet.jpg"))
# # ]
# # photos_melanie_thierry = [
#   File.open(Rails.root.join("public/seed_images/melanie_thierry.jpg")),
#   File.open(Rails.root.join("public/seed_images/melanie_thierry.jpg")),
#   File.open(Rails.root.join("public/seed_images/melanie_thierry.jpg"))
# ]
# # photos_emma_mackey = [
#   File.open(Rails.root.join("public/seed_images/emma_mackey.jpg")),
#   File.open(Rails.root.join("public/seed_images/emma_mackey.jpg")),
#   File.open(Rails.root.join("public/seed_images/emma_mackey.jpg"))
# ]
photos_zoe_kravitz = [
  File.open(Rails.root.join("public/seed_images/zoe_kravitz.jpg")),
  File.open(Rails.root.join("public/seed_images/zoe_kravitz.jpg")),
  File.open(Rails.root.join("public/seed_images/zoe_kravitz.jpg"))
]
# # photos_natalie_portman = [
#   File.open(Rails.root.join("public/seed_images/natalie_portman.jpg")),
#   File.open(Rails.root.join("public/seed_images/natalie_portman.jpg")),
#   File.open(Rails.root.join("public/seed_images/natalie_portman.jpg"))
# ]
# # photos_tom_leeb = [
#   File.open(Rails.root.join("public/seed_images/tom_leeb.jpg")),
#   File.open(Rails.root.join("public/seed_images/tom_leeb.jpg")),
#   File.open(Rails.root.join("public/seed_images/tom_leeb.jpg"))
# ]
# # photos_pierre_niney = [
#   File.open(Rails.root.join("public/seed_images/pierre_niney.jpg")),
#   File.open(Rails.root.join("public/seed_images/pierre_niney.jpg")),
#   File.open(Rails.root.join("public/seed_images/pierre_niney.jpg"))
# ]
# # photos_pio_marmai = [
#   File.open(Rails.root.join("public/seed_images/pio_marmai.jpg")),
#   File.open(Rails.root.join("public/seed_images/pio_marmai.jpg")),
#   File.open(Rails.root.join("public/seed_images/pio_marmai.jpg"))
# ]
# # photos_robert_pattinson = [
#   File.open(Rails.root.join("public/seed_images/robert_pattinson.jpg")),
#   File.open(Rails.root.join("public/seed_images/robert_pattinson.jpg")),
#   File.open(Rails.root.join("public/seed_images/robert_pattinson.jpg"))
# ]
# # photos_rege_jean_page = [
#   File.open(Rails.root.join("public/seed_images/rege_jean_page.jpg")),
#   File.open(Rails.root.join("public/seed_images/rege_jean_page.jpg")),
#   File.open(Rails.root.join("public/seed_images/rege_jean_page.jpg"))
# ]

famous_users_photos = [
#   photos_juliette_armanet,
#   photos_melanie_thierry,
#   photos_emma_mackey,
  photos_zoe_kravitz
#   photos_natalie_portman,
#   photos_tom_leeb,
#   photos_pierre_niney,
#   photos_pio_marmai,
#   photos_robert_pattinson,
#   photos_rege_jean_page
]

photos = team_users_photos + wagon_users_photos + famous_users_photos

# <--- Create Users --->

users_data = team_users_data + wagon_users_data + famous_users_data

users_data.each_with_index do |user_data, index|
  user = User.new(user_data)
  user.sign = AstrologyApi.new(api_uid, api_key).horoscope(user.birth_date, user.birth_hour, user.birth_location, user.birth_country)['planets'].first['sign']
  user.rising = AstrologyApi.new(api_uid, api_key).horoscope(user.birth_date, user.birth_hour, user.birth_location, user.birth_country)['houses'].first['sign']
  user.moon = AstrologyApi.new(api_uid, api_key).horoscope(user.birth_date, user.birth_hour, user.birth_location, user.birth_country)['planets'][1]['sign']
  user.planets = AstrologyApi.new(api_uid, api_key).planets_location(user.birth_date, user.birth_hour, user.birth_location, user.birth_country)
  user.wheel_chart = AstrologyApi.new(api_uid, api_key).wheel_chart(user.birth_date, user.birth_hour, user.birth_location, user.birth_country, "#2E3A59", "#ffffff", "#ffffff", "#2E3A59")
  user.personality_report = AstrologyApi.new(api_uid, api_key).personality_report(user.birth_date, user.birth_hour, user.birth_location, user.birth_country)
  photos[index].each do |photo|
    user.photos.attach(io: photo, filename: user.username, content_type: 'jpg')
  end
  # user.photos.attach(io: photos[index], filename: user.username, content_type: 'jpg')
  user.save!
  p "*** #{user.username} ***"
end

# <--- Calculate and attach affinity Scores and reports --->

users = User.all

users.each do |user|
  potential_mates = User.where(gender: user.looking_for).where.not(id: user.id)
  score_collection = {}
  partner_report_collection = {}
  sun_report_collection = {}
  # love_compatibility_report_collection = {}
  potential_mates.each do |mate|
    if mate.gender == 2
      mate_score = AstrologyApi.new(api_uid, api_key).match_percentage(
        user.birth_date,
        user.birth_hour,
        user.birth_location,
        user.birth_country,
        mate.birth_date,
        mate.birth_hour,
        mate.birth_location,
        mate.birth_country
      )
      score_collection.store(mate.id, mate_score)
    else
      mate_score = AstrologyApi.new(api_uid, api_key).match_percentage(
        mate.birth_date,
        mate.birth_hour,
        mate.birth_location,
        mate.birth_country,
        user.birth_date,
        user.birth_hour,
        user.birth_location,
        user.birth_country
      )
      score_collection.store(mate.id, mate_score)
    end

    mate_partner_report = AstrologyApi.new(api_uid, api_key).partner_report(
      user.birth_date,
      user.gender,
      mate.birth_date,
      mate.gender,
      mate.username
    )
    partner_report_collection.store(mate.id, mate_partner_report)

    mate_sun_report = AstrologyApi.new(api_uid, api_key).sign_report(
      mate.birth_date,
      mate.birth_hour,
      mate.birth_location,
      mate.birth_country,
      'sun'
    )
    sun_report_collection.store(mate.id, mate_sun_report)

    # mate_love_compatibility_report = AstrologyApi.new(api_uid, api_key).love_compatibility_report(
    #   user.birth_date,
    #   user.birth_hour,
    #   user.birth_location,
    #   user.birth_country,
    #   mate.birth_date,
    #   mate.birth_hour,
    #   mate.birth_location,
    #   mate.birth_country
    # )
    # love_compatibility_report_collection.store(mate.id, mate_love_compatibility_report)
  end
  ordered_score_collection = score_collection.sort_by { |_id, score| score }
  user.affinity_scores = ordered_score_collection.reverse.to_h
  user.partner_reports = partner_report_collection
  user.mate_sun_reports = sun_report_collection
  # user.love_compatibility_reports = love_compatibility_report_collection
  puts "*** #{user.username} complementary attachments ok ***"
  user.save!
end

puts "#{User.all.length} users created successfully!"

# <=== MATCHES SEEDING ===>

# <--- Select users --->

# maria = User.find_by_email('leonor.varela91330@gmail.com')
# boris = User.find_by_email('boris_bourdet@hotmail.com')
# etienne = User.find_by_email('etiennededi@hotmail.fr')
# rege_jean_page = User.find_by_email('rj.page@astrocrush.io')
# robert_pattinson = User.find_by_email('r.pattinson@astrocrush.io')
# pio_marmai = User.find_by_email('p.marmai@astrocrush.io')
# pierre_niney = User.find_by_email('p.niney@astrocrush.io')
# tom_leeb = User.find_by_email('t.leeb@astrocrush.io')

# <--- Create Chatrooms --->

# puts "Creating Chatrooms..."

# 7.times { Chatroom.new.save! }

# puts "Finished!"

# <--- Create Matches --->

# puts "Creating Matches..."

# first_match = {
#   status: "accepted",
#   user_id: maria.id,
#   mate_id: boris.id,
#   chatroom_id: Chatroom.all[0].id
# }

# second_match = {
#   status: "accepted",
#   user_id: maria.id,
#   mate_id: etienne.id,
#   chatroom_id: Chatroom.all[1].id
# }

# third_match = {
#   status: "accepted",
#   user_id: maria.id,
#   mate_id: rege_jean_page.id,
#   chatroom_id: Chatroom.all[2].id
# }

# fourth_match = {
#   status: "accepted",
#   user_id: maria.id,
#   mate_id: robert_pattinson.id,
#   chatroom_id: Chatroom.all[3].id
# }

# fifth_match = {
#   status: "accepted",
#   user_id: maria.id,
#   mate_id: pio_marmai.id,
#   chatroom_id: Chatroom.all[4].id
# }

# sixth_match = {
#   status: "accepted",
#   user_id: maria.id,
#   mate_id: pierre_niney.id,
#   chatroom_id: Chatroom.all[5].id
# }

# seventh_match = {
#   status: "accepted",
#   user_id: maria.id,
#   mate_id: tom_leeb.id,
#   chatroom_id: Chatroom.all[6].id
# }

# matches = [first_match, second_match, third_match, fourth_match, fifth_match, sixth_match, seventh_match]

# matches.each do |match|
#   match_instance = Match.new(match)
#   match_instance.save!
# end

# puts "Finished!"

# # <--- Create Messages --->

# puts "Creating Messages..."

# Message.new(
#   content: "coucou!",
#   chatroom_id: Chatroom.first.id,
#   user_id: maria.id
# ).save!

# Message.new(
#   content: "yo!",
#   chatroom_id: Chatroom.first.id,
#   user_id: boris.id
# ).save!

# Message.new(
#   content: "ça va ?",
#   chatroom_id: Chatroom.first.id,
#   user_id: maria.id
# ).save!

# puts 'Finished!'

# SAVE

# users_data = team_users_data + wagon_users_data #+ famous_users_data

# users_data.each_with_index do |user_data, index|
#   user = User.new(user_data)
#   user.sign = AstrologyApi.new(api_uid, api_key).horoscope(user.birth_date, user.birth_hour, user.birth_location, user.birth_country)['planets'].first['sign']
#   user.rising = AstrologyApi.new(api_uid, api_key).horoscope(user.birth_date, user.birth_hour, user.birth_location, user.birth_country)['houses'].first['sign']
#   user.moon = AstrologyApi.new(api_uid, api_key).horoscope(user.birth_date, user.birth_hour, user.birth_location, user.birth_country)['planets'][1]['sign']
#   user.planets = AstrologyApi.new(api_uid, api_key).planets_location(user.birth_date, user.birth_hour, user.birth_location, user.birth_country)
#   user.wheel_chart = AstrologyApi.new(api_uid, api_key).wheel_chart(user.birth_date, user.birth_hour, user.birth_location, user.birth_country, "#2E3A59", "#ffffff", "#ffffff", "#2E3A59")
#   user.personality_report = AstrologyApi.new(api_uid, api_key).personality_report(user.birth_date, user.birth_hour, user.birth_location, user.birth_country)
#   user.photos.attach(io: photos[index], filename: user.username, content_type: 'jpg')
#   user.save!
#   p "*** #{user.username} ***"
# end
