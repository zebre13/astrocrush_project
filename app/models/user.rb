class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many_attached :photos
  has_many :matches, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :username, presence: true
  validates :email, presence: true
  # validates :email, presence: true, /.+@.+\.\w{2,3}/
  # validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a- z]{2,})$/i
  validates :birth_date, presence: true
  # validates_date :date_of_birth, :after => Proc.new { Date.today }
  validates :birth_hour, presence: true
  validates :birth_location, presence: true
  validates :gender, presence: true
  validates :looking_for, presence: true
  # validate :user_is_adult

  ZODIAC = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]

  def create_my_zodiac
    first = 0

    ZODIAC.each_with_index do |sign, index|
      if sign == current_user.rising.capitalize
        first = index
      end
    end
    first_half = ZODIAC.slice(first..-1)
    second_half = ZODIAC.slice(0..(first-1))

    @my_zodiac = first_half + second_half
  end

  def find_planets
    @my_zodiac.each do |sign|
      planet = current_user.planets.select { |_, v| v.select { |_, value| value.include? sign } }
      sign = { planet: planet.key, house: planet.house }
    end
  end

    # private

    # def user_is_adult
    #   if Date.today.year - birth_date.year < 18
    #     self.errors.add(:birth_date, "User must be over 18 years old")
    #   end
    # end
end
