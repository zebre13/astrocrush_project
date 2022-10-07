require 'rails_helper'
require_relative '../../app/services/affinities'
require_relative '../../app/services/astroprofil'
require_relative '../../app/services/geocode'
require 'faker'

ASTROPROFIL = Astroprofil.new
AFFINITIES = Affinities.new
GEOCODE = Geocode.new

RSpec.describe User, type: :model do

  context 'Registration'
  it 'should persist a user' do
    user = create_male

    expect(User.count).to eq(1)
  end

  it 'should set coordinates for the user' do
    user = create_male
    GEOCODE.coordinates(user, '168.212.226.204')
    user.save!

    expect(user.local_lat).not_to eq(nil)
    expect(user.local_lon).not_to eq(nil)
  end

  it 'should create an astroprofil' do
    user = create_male
    ASTROPROFIL.profil(user)
    user.save!

    expect(user.planets).not_to eq(nil)
  end

  it 'should create a partner report' do
    user = create_male
    create_ten_females
    mates = (User.where(gender: user.looking_for).where.not(id: user.id)).sample(10)
    AFFINITIES.partner_report(user, mates)
    user.save!

    expect(user.partner_reports).not_to eq(nil)
  end

  it 'should create a sun report' do
    user = create_male
    create_ten_females
    mates = (User.where(gender: user.looking_for).where.not(id: user.id)).sample(10)
    AFFINITIES.sign_report(user, mates)
    user.save!

    expect(user.mate_sun_reports).not_to eq(nil)
  end

  it 'should create a match percentage' do
    user = create_male
    create_ten_females
    mates = (User.where(gender: user.looking_for).where.not(id: user.id)).sample(10)
    AFFINITIES.match_percentage(user, mates)
    user.save!

    expect(User.last.affinity_scores).not_to eq(nil)
  end

  private

  def create_male
    male = { username: Faker::Name.name,
      email: Faker::Internet.email,
      password: '******',
      description: Faker::Lorem.sentence(word_count: 6),
      hobbies: ['Chamber music', 'Astrology'],
      birth_date: '26/06/1977',
      birth_hour: '05:30',
      birth_location: 'Aix-en-Provence',
      birth_country: 'FR',
      latitude: '43.529742',
      longitude: '5.447427',
      gender: 1,
      looking_for: 2 }

      photo = File.open(Rails.root.join("public/seed_images/boris_1.jpg"))

      user = User.new(male)
      user.photos.attach(io: photo, filename: user.username, content_type: 'jpg')
      user.save!

      return user
    end

  def create_ten_females
    ten_females = []
    female = { username: Faker::Name.name,
      email: Faker::Internet.email,
      password: '******',
      description: Faker::Lorem.sentence(word_count: 6),
      hobbies: ['Chamber music', 'Astrology'],
      birth_date: '26/06/1977',
      birth_hour: '05:30',
      birth_location: 'Aix-en-Provence',
      birth_country: 'FR',
      latitude: '43.529742',
      longitude: '5.447427',
      gender: 2,
      looking_for: 1 }

      photo = File.open(Rails.root.join("public/seed_images/boris_1.jpg"))

      10.times do
        user = User.new(female)
        user.photos.attach(io: photo, filename: user.username, content_type: 'jpg')
        ten_females << user
      end

    return ten_females
  end
end
