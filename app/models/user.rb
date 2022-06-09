class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many_attached :photos
  has_many :matches

  validates :username, presence: true
  # validates :email, presence: true, /.+@.+\.\w{2,3}/
  # validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a- z]{2,})$/i
  # validates :birth_date, presence: true
  # validates_date :date_of_birth, :after => Proc.new { Date.today }
  # validates :birth_hour, presence: true
  # validates :birth_location, presence: true
  validates :gender, presence: true
  validates :looking_for, presence: true
  # validate :user_is_adult

  # private

  # def user_is_adult
  #   if Date.today.year - birth_date.year < 18
  #     self.errors.add(:birth_date, "user must be aged above 18")
  #   end
  # end

end
