require 'rails_helper'
require_relative '../../app/services/affinities'
require_relative '../../app/services/astroprofil'
require_relative '../../app/services/geocode'

RSpec.describe User, type: :model do
  ASTROPROFIL = Astroprofil.new
  AFFINITIES = Affinities.new
  GEOCODE = Geocode.new

  boris_bourdet = {
    username: 'Boris',
    email: 'boris_bourdet@hotmail.com',
    password: 'azerty',
    description: "For a long time, I alternated abs and hanging belly.",
    hobbies: ['Chamber music', 'Astrology'],
    birth_date: '26/06/1977',
    birth_hour: '05:30',
    birth_location: 'Aix-en-Provence',
    birth_country: 'FR',
    latitude: '43.529742',
    longitude: '5.447427',
    gender: 1,
    looking_for: 2
  }
  photo = File.open(Rails.root.join("public/seed_images/boris_1.jpg"))

  # context 'User registration'
  it 'should persist a user' do
    user = User.new(boris_bourdet)
    mates = (User.where(gender: user.looking_for).where.not(id: user.id)).sample(10)
    user.photos.attach(io: photo, filename: user.username, content_type: 'jpg')
    ASTROPROFIL.profil(user)
    GEOCODE.coordinates(user, '168.212.226.204')
    AFFINITIES.partner_report(user, mates)
    AFFINITIES.sun_reports(user, mates)
    AFFINITIES.match_percentage(user, mates)
    user.save!

    expect(User.count).to eq(1)
  end
end
