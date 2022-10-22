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
    it 'shouldnt validate falsy users' do
      user = User.new
      user.validate

      expect(user.errors.messages).to include(:username, :email, :birth_date, :birth_hour, :photos, :birth_location, :gender, :looking_for)
      expect(user.valid?).to be false
    end

    it 'should validate users' do
      user = build(:user) do |user|
        photo = File.open(Rails.root.join("public/seed_images/boris_1.jpg"))
        user.photos.attach(io: photo, filename: user.username, content_type: 'jpg')
      end
      user.validate

      expect(user.valid?).to be true
    end
  end

  context 'creation' do
    it 'should persist a user' do
      photo = File.open(Rails.root.join("public/seed_images/boris_1.jpg"))

      user = build(:user)
      user.photos.attach(io: photo, filename: user.username, content_type: 'jpg')
      user.save

      expect(user.valid?).to be true
    end

    it 'should set coordinates for the user' do
      user = create_male
      GEOCODE.coordinates(user, '168.212.226.204')

      expect(user.local_lat).not_to eq(nil)
      expect(user.local_lon).not_to eq(nil)
    end

    it 'should create an astroprofil' do
      user = create_male
      ASTROPROFIL.profil(user)

      expect(user.planets).not_to eq(nil)
    end

    it 'should create a partner report' do
      user = create_male
      create_ten_females
      mates = (User.where(gender: user.looking_for).where.not(id: user.id))
      AFFINITIES.partner_report(user, mates)

      expect(user.partner_reports).not_to eq(nil)
    end

    it 'should create a match percentage' do
      user = create_male
      create_ten_females
      mates = (User.where(gender: user.looking_for).where.not(id: user.id))
      AFFINITIES.match_percentage(user, mates)

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

  def create_ten_females
    ten_females = []
    photo = File.open(Rails.root.join("public/seed_images/boris_1.jpg"))

    10.times do
      ten_females << build(:user_female) do |user|

      end
    end

    return ten_females
  end
end
