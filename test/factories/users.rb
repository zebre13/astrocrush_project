FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.email }
    password { '******' }
    description { Faker::Lorem.sentence(word_count: 6) }
    hobbies { ['Chamber music', 'Astrology'] }
    birth_date { '26/06/1977' }
    birth_hour { '05:30' }
    birth_location { 'Aix-en-Provence' }
    birth_country { 'FR' }
    latitude { '43.529742' }
    longitude { '5.447427' }
    gender { 1 }
    looking_for { 2 }

    factory :user_female do
      gender { 2 }
      looking_for { 1 }
    end
  end

end
