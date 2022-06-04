class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many_attached :photos

  validates :username, presence: true
  # validates :email, presence: true
  validates :description, presence: true, uniqueness: true
  validates :birth_date, presence: true
  validates :birth_hour, presence: true
  validates :birth_location, presence: true
end
