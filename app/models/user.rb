class User < ApplicationRecord
  attr_reader :my_zodiac

  serialize :affinity_scores, Hash
  serialize :planets, Hash
  serialize :horoscope_data, Hash
  serialize :personality_report, Array
  serialize :hobbies, Array
  serialize :partner_reports, Hash
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many_attached :photos
  has_many :matches, dependent: :destroy
  has_many :messages, dependent: :destroy
  # has_many :chatrooms, ->(user) {
  #   unscope(where: :user_id)
  #     .where("first_user_id = :user_id OR second_user_id = :user_id", user_id: user.id)
  # },
  # class_name: 'Chatroom', dependent: :destroy

  validates :email, presence: true
  # validates :email, presence: true, /.+@.+\.\w{2,3}/
  # validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a- z]{2,})$/i
  # validates :username, presence: true
  # validates :birth_date, presence: true
  # validates_date :date_of_birth, :after => Proc.new { Date.today }
  # validates :birth_hour, presence: true
  # validates :birth_location, presence: true
  # validates :photos, presence: true
  # validates :gender, presence: true
  # validates :looking_for, presence: true
  # validate :user_is_adult?
  validates_length_of :description, maximum: 500

  cattr_accessor :form_steps do
    %w[sign_up onboarding_birth onboarding_profile]
  end

  attr_accessor :form_step

  def matches
    Match.where(user: self).or(Match.where(mate: self))
  end

  # def user_is_adult?
  #   if Date.today.year - birth_date.year < 18
  #     self.errors.add(:birth_date, "must be over 18 years old")
  #   end
  # end

  def online?
    updated_at > 2.minutes.ago
  end
end
