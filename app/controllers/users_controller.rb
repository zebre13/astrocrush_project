require 'json'
# require_relative '../services/astrology_api'
API_UID = ENV["API_UID"]
API_KEY = ENV["API_KEY"]
API_CALL = AstrologyApi.new(API_UID, API_KEY)

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

    @users_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    # On rejette tous les users qui sont dans les matchs du current user.
    @users = @users_by_gender.reject do |user|
      Match.where("(user_id = ?) OR (mate_id = ? AND status IN (1, 2))", current_user.id, current_user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
      # Match.where("user_id = ? OR (mate_id = ? AND status IN ?)", current_user.id, current_user.id, [1, 2]).pluck(:mate_id, :user_id).flatten.include?(user.id)
    end
    p "THIS ISSSS THE ARRAY WE WANT TO BE EMPTYYYY"
    p @users
  end

  def show
    @mate = User.find(params[:id])
  end

  def test
    @users_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    # On rejette tous les users qui sont dans les matchs du current user.
    @users = @users_by_gender.reject do |user|
      Match.where("(user_id = ? AND status = 0) OR (mate_id = ? AND status IN (1, 2))", current_user.id, current_user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
    end
  end

  def astroboard
    @daily_horoscope = AstrologyApi.new(API_UID, API_KEY).daily_horoscope(current_user.sign)
    @zodiac_compatibility = AstrologyApi.new(API_UID, API_KEY).zodiac_compatibility(current_user.sign)
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

  def dashboard
  end

  # def new_user_api_calls
  #   horo_elements = API_CALL.horoscope(current_user.birth_date, current_user.birth_hour, current_user.birth_location, current_user.birth_country)
  #   current_user.sign = horo_elements['planets'].first['sign']
  #   current_user.rising = horo_elements['houses'].first['sign']
  #   current_user.moon = horo_elements['planets'][1]['sign']
  #   current_user.planets = API_CALL.planets_location(current_user.birth_date, current_user.birth_hour, current_user.birth_location, current_user.birth_country)
  #   current_user.wheel_chart = API_CALL.wheel_chart(current_user.birth_date, current_user.birth_hour, current_user.birth_location, current_user.birth_country, "#2E3A59", "#ffffff", "#ffffff", "#2E3A59")
  #   current_user.personality_report = API_CALL.personality_report(current_user.birth_date, current_user.birth_hour, current_user.birth_location, current_user.birth_country)

  #   # current_user.photos.each do |photo|
  #   #   current_user.photos.attach(io: photo, filename: current_user.username, content_type: 'jpg')
  #   # end
  #   p "création des signes planetes etc OK"

  #   # Selection des personnes correspondant aux critères de recherche de ce nouvel user
  #   potential_mates = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
  #   p "potential mates ok"
  #   score_collection = {}
  #   partner_report_collection = {}
  #   sun_report_collection = {}

  #   # Calcul du score de match avec chaque potential mate
  #   potential_mates.each do |mate|
  #     if mate.gender == 2
  #       mate_score = AstrologyApi.new(api_uid, api_key).match_percentage(
  #         current_user.birth_date,
  #         current_user.birth_hour,
  #         current_user.birth_location,
  #         current_user.birth_country,
  #         mate.birth_date,
  #         mate.birth_hour,
  #         mate.birth_location,
  #         mate.birth_country
  #       )
  #       score_collection.store(mate.id, mate_score)
  #     else
  #       mate_score = AstrologyApi.new(api_uid, api_key).match_percentage(
  #         mate.birth_date,
  #         mate.birth_hour,
  #         mate.birth_location,
  #         mate.birth_country,
  #         current_user.birth_date,
  #         current_user.birth_hour,
  #         current_user.birth_location,
  #         current_user.birth_country
  #       )
  #       p "Score match ok"
  #       score_collection.store(mate.id, mate_score)
  #     end
  #     # Call api pour obtenir les textes descriptifs
  #     mate_partner_report = AstrologyApi.new(api_uid, api_key).partner_report(
  #       current_user.birth_date,
  #       current_user.gender,
  #       mate.birth_date,
  #       mate.gender,
  #       mate.username
  #     )
  #     partner_report_collection.store(mate.id, mate_partner_report)

  #     # Descriptif de ton signe
  #     mate_sun_report = AstrologyApi.new(api_uid, api_key).sign_report(
  #       mate.birth_date,
  #       mate.birth_hour,
  #       mate.birth_location,
  #       mate.birth_country,
  #       'sun'
  #     )
  #     sun_report_collection.store(mate.id, mate_sun_report)
  #   end

  #   ordered_score_collection = score_collection.sort_by { |_id, score| score }
  #   current_user.affinity_scores = ordered_score_collection.reverse.to_h
  #   current_user.partner_reports = partner_report_collection
  #   current_user.mate_sun_reports = sun_report_collection
  #   current_user.save!
  # end

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
    hash_planets = eval(current_user.planets)
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
