class UsersController < ApplicationController
<<<<<<< HEAD
  ZODIAC = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
  LOGOS = {
    Sun: "☉ ",
    Moon: "☽ ",
    Mercury: "☿ ",
    Venus: "♀︎ ",
    Mars: "♂︎ ",
    Jupiter: "♃ ",
    Saturn: "♄ ",
    Uranus: "⛢ ",
    Neptune: "♆ ",
    Pluto: "♇ "
  }
=======
  require 'json'
>>>>>>> master

  def index
    # Faire en sorte que l'index proposé corresponde a ce que l'utilisateur recherche
    @matches = current_user.matches

    @users_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    # On rejette tous les users qui sont dans les matchs du current user.
    @users = @users_by_gender.reject do |user|
      Match.where("(user_id = ? AND status = 0) OR (mate_id = ? AND status IN (1, 2))", current_user.id, current_user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
      # Match.where("user_id = ? OR (mate_id = ? AND status IN ?)", current_user.id, current_user.id, [1, 2]).pluck(:mate_id, :user_id).flatten.include?(user.id)
    end
    p "THIS ISSSS THE ARRAY WE WANT TO BE EMPTYYYY"
    p @users
  end

  def show
    @mate = User.find(params[:id])
  end

  def dashboard
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
    # @first_sign = find_planets(1)
    # @second_sign = find_planets(2)
    # @third_sign = find_planets(3)
    # @fourth_sign = find_planets(4)
    # @fifth_sign = find_planets(5)
    # @sixth_sign = find_planets(6)
    # @seventh_sign = find_planets(7)
    # @eighth_sign = find_planets(8)
    # @ninth_sign = find_planets(9)
    # @tenth_sign = find_planets(10)
    # @eleventh_sign = find_planets(11)
  end

  # private

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
