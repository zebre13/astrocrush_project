require 'json'
require_relative '../services/astrology_api'

class UsersController < ApplicationController
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])

  ZODIAC = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
  LOGOS = { Sun: "☉ ", Moon: "☽ ", Mercury: "☿ ", Venus: "♀︎ ", Mars: "♂︎ ", Jupiter: "♃ ", Saturn: "♄ ", Uranus: "♅ ", Neptune: "♆ ", Pluto: "♇ " }

  def index
    mini_date = Date.today - (current_user.minimal_age * 365)
    max_date = Date.today - (current_user.maximum_age * 365)

    # selectionner les utilisateurs par preferences age / rayon / gender
    users_by_preference = User.where(gender: current_user.looking_for).where.not(id: current_user.id).where("(birth_date < ?)", mini_date).where("(birth_date > ?)", max_date)

    # Ne garder que les utilisateurs qui ont un score de match calculé avec moi
    users_with_score = users_by_preference.select do |user|
      user.affinity_scores.keys.include?(current_user.id)
    end

    # On rejette tous les users qui sont dans les matchs du current user.
    @users = users_with_score.reject do |user|
      Match.where("(user_id = ?) OR (mate_id = ? AND status IN (1, 2))", current_user.id, current_user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
    end
  end

  def show
    @mate = User.find(params[:id])
    @mate_sun_report = I18n.t "planets_in_signs.Sun.#{@mate.sign.to_sym}"
  end

  def astroboard
    @daily_horoscope = API_CALL.daily_horoscope(current_user.sign)
    @zodiac_compatibility = API_CALL.zodiac_compatibility(current_user.sign)
    # @my_zodiac = create_zodiac
    # @signs = [find_planets(1), find_planets(2), find_planets(3), find_planets(4), find_planets(5), find_planets(6), find_planets(7), find_planets(8), find_planets(9), find_planets(10), find_planets(11)]
    @my_signs = my_signs(current_user.horoscope_data)
    @my_planets = my_planets_with_logos(current_user.horoscope_data)
    @my_houses = my_houses(current_user.horoscope_data)
  end

  private

  # Array of sorted planets used for the construction of the astroboard table
  def my_planets(horoscope_data)
    planets = {}
    horoscope_data["planets"].first(10).each { |data| planets[data["name"]] = data["full_degree"] }
    asc_d = horoscope_data["ascendant"]
    adj_planets = planets.transform_values { |d| d <= asc_d ? (d - asc_d + 360) : (d - asc_d) }
    ordered_planets = adj_planets.sort_by { |_key, value| value }.to_h
    ordered_planets.keys.unshift "Ascendant"
  end

  # Array of sorted signs used for display in the astroboard table
  def my_signs(horoscope_data)
    signs = []
    my_planets(horoscope_data).each do |planet|
      if planet == "Ascendant"
        signs << horoscope_data["houses"].first["sign"]
      else
        horoscope_data["planets"].each { |data| signs << data["sign"] if data.has_value?(planet) }
      end
    end
    signs
  end

  # Array of sorted planets with logos used for display in the astroboard table
  def my_planets_with_logos(horoscope_data)
    my_planets = my_planets(horoscope_data)
    my_planets_with_logos = my_planets.map do |planet|
      if planet == "Ascendant"
        "Ascendant"
      else
        "#{LOGOS[planet.to_sym]} #{planet}"
      end
    end
    my_planets_with_logos
  end

  # Array of sorted houses used for display in the astroboard table
  def my_houses(horoscope_data)
    houses = []
    my_planets(horoscope_data).each do |planet|
      if planet == "Ascendant"
        houses << 1
      else
        horoscope_data["planets"].each { |data| houses << data["house"] if data.has_value?(planet) }
      end
    end
    houses
  end

  # def create_zodiac
  #   cut = 0

  #   ZODIAC.each_with_index do |sign, index|
  #     cut = index if sign == current_user.rising.capitalize
  #   end
  #   ZODIAC.slice(cut..) + ZODIAC.slice(0..(cut - 1))
  # end

  # def find_planets(zodiac_index)
  #   hash_planets = current_user.planets
  #   planets = []
  #   data_to_display = {}
  #   hash_planets.each do |planet, hash|
  #     if @my_zodiac[zodiac_index] == hash[:sign]
  #       data_to_display["sign"] = hash[:sign]
  #       data_to_display["planet"] = planet.to_s.capitalize
  #       data_to_display["house"] = hash[:house]
  #       data_to_display["logo"] = LOGOS[planet]
  #       planets << data_to_display
  #       data_to_display = {}
  #     end
  #   end
  #   return planets
  # end
end
