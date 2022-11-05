require 'rails_helper'
require_relative '../../app/services/affinities'
require_relative '../../app/services/astroprofil'
require_relative '../../app/services/geocode'
require 'faker'

ASTROPROFIL = Astroprofil.new
AFFINITIES = Affinities.new
GEOCODE = Geocode.new

RSpec.describe User, type: :model do
  context 'validation' do
    user = User.new
    user.validate

    it 'shouldnt validate falsy users' do
      expect(user.errors.messages).to include(:username, :email, :birth_date, :birth_hour, :photos, :birth_location, :gender, :looking_for)
      expect(user.valid?).to be false
    end

    user = build(:user) do |male|
      photo = File.open(Rails.root.join("public/seed_images/boris_1.jpg"))
      male.photos.attach(io: photo, filename: male.username, content_type: 'jpg')
    end

    it 'should validate users' do
      expect(user.valid?).to be true
    end
  end

  context 'creation' do
    user = build(:user) do |user|
      photo = File.open(Rails.root.join("public/seed_images/boris_1.jpg"))
      user.photos.attach(io: photo, filename: user.username, content_type: 'jpg')
    end
    female = build(:user_female) do |user|
      photo = File.open(Rails.root.join("public/seed_images/ghita_1.jpg"))
      user.photos.attach(io: photo, filename: user.username, content_type: 'jpg')
    end

    ASTROPROFIL.profil(user)
    GEOCODE.coordinates(user, '168.212.226.204')
    AFFINITIES.partner_report(user, female)
    AFFINITIES.match_percentage(user, female)

    it 'should persist a user' do
      expect(user.valid?).to be true
    end

    it 'should set coordinates for the user' do
      expect(user.local_lat).not_to eq(nil)
      expect(user.local_lon).not_to eq(nil)
    end

    it 'should create an astroprofil' do
      expect(user.horoscope_data).not_to eq(nil)
    end

    it 'should create a partner report' do
      expect(user.partner_reports).not_to eq(nil)
    end

    it 'should create a match percentage' do
      expect(User.last.affinity_scores).not_to eq(nil)
    end
  end

  private

  def create_male
    build(:user) do |user|
      photo = File.open(Rails.root.join("public/seed_images/boris_1.jpg"))
      user.photos.attach(io: photo, filename: user.username, content_type: 'jpg')
    end
  end

  def create_female
    build(:user_female) do |user|
      photo = File.open(Rails.root.join("public/seed_images/ghita_1.jpg"))
      user.photos.attach(io: photo, filename: user.username, content_type: 'jpg')
    end
  end
end
