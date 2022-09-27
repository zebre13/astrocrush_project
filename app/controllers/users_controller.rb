require 'json'
require_relative '../services/astrology_api'

API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])

class UsersController < ApplicationController

  ZODIAC = [
    "Aries",
    "Taurus",
    "Gemini",
    "Cancer",
    "Leo",
    "Virgo",
    "Libra",
    "Scorpio",
    "Sagittarius",
    "Capricorn",
    "Aquarius",
    "Pisces"
  ]

  LOGOS = {
    Sun: "☉ ",
    Moon: "☽ ",
    Mercury: "☿ ",
    Venus: "♀︎ ",
    Mars: "♂︎ ",
    Jupiter: "♃ ",
    Saturn: "♄ ",
    Uranus: "♅ ",
    Neptune: "♆ ",
    Pluto: "♇ "
  }

  def index
    # Faire en sorte que l'index proposé corresponde a ce que l'utilisateur recherche
    @matches = current_user.matches

    #selectionner les utilisateurs par preferences age / rayon / gender
    @users_by_preference = User.where(gender: current_user.looking_for).where.not(id: current_user.id)

    #parmi les utilisateurs selectionnés par préférence rejecter les utilisateurs si affinity_score n'existe pas
    @users_with_score = @users_by_preference.reject do |user|
      user.affinity_scores == nil
    end
    # On rejette tous les users qui sont dans les matchs du current user.
    @users = @users_with_score.reject do |user|
      Match.where("(user_id = ?) OR (mate_id = ? AND status IN (1, 2))", current_user.id, current_user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
      # Match.where("user_id = ? OR (mate_id = ? AND status IN ?)", current_user.id, current_user.id, [1, 2]).pluck(:mate_id, :user_id).flatten.include?(user.id)
    end
    p "THIS ISSSS THE ARRAY WE WANT TO BE EMPTYYYY"
    p @users
  end

  def show
    @mate = User.find(params[:id])
  end

  def astroboard
    @daily_horoscope = API_CALL.daily_horoscope(current_user.sign)
    @zodiac_compatibility = API_CALL.zodiac_compatibility(current_user.sign)
    @my_zodiac = create_zodiac
    @signs = [find_planets(1),
              find_planets(2),
              find_planets(3),
              find_planets(4),
              find_planets(5),
              find_planets(6),
              find_planets(7),
              find_planets(8),
              find_planets(9),
              find_planets(10),
              find_planets(11)]
  end

  private

  def create_zodiac
    cut = 0

    ZODIAC.each_with_index do |sign, index|
      if sign == current_user.rising.capitalize
        cut = index
      end
    end

    ZODIAC.slice(cut..-1) + ZODIAC.slice(0..(cut - 1))
  end

  def find_planets(zodiac_index)
    hash_planets = current_user.planets
    planets = []
    data_to_display = {}
    hash_planets.each do |planet, hash|
      if @my_zodiac[zodiac_index] == hash[:sign]
        data_to_display["sign"] = hash[:sign]
        data_to_display["planet"] = planet.to_s.upcase
        data_to_display["house"] = hash[:house]
        data_to_display["logo"] = LOGOS[planet]
        planets << data_to_display
        data_to_display = {}
      end
    end
    return planets
  end
end

# # sign =  {planet: planet, house: house}
# hash[:sign] = planet: hash.key
