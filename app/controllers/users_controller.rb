require 'json'
require_relative '../services/astrology_api'
require_relative '../services/sun_reports'

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
    @mate_sun_report = SUN_REPORTS[@mate.sign.to_sym]
  end

  def astroboard
    @daily_horoscope = API_CALL.daily_horoscope(current_user.sign)
    @zodiac_compatibility = API_CALL.zodiac_compatibility(current_user.sign)
    @my_zodiac = create_zodiac
    @signs = [find_planets(1), find_planets(2), find_planets(3), find_planets(4), find_planets(5), find_planets(6), find_planets(7), find_planets(8), find_planets(9), find_planets(10), find_planets(11)]
  end

  private

  def create_zodiac
    cut = 0

    ZODIAC.each_with_index do |sign, index|
      cut = index if sign == current_user.rising.capitalize
    end
    ZODIAC.slice(cut..) + ZODIAC.slice(0..(cut - 1))
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

  # def update_index
  #   # 2. Utiliser current_user.search_perimeter ( a créer et migrer et mettre dans le signup et edit).
  #   users_by_preference = User.where(gender: current_user.looking_for).where.not(id: current_user.id)

  #   # 3. Puis exclure ceux avec qui j'ai déja matché ou que j'ai déja disliké (comme dans l'index controlleur de base).
  #   users_by_preference_not_swiped = users_by_preference.reject do |user|
  #     Match.where("(user_id = ?) OR (mate_id = ? AND status IN (1, 2))", current_user.id, current_user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
  #     # Match.where("user_id = ? OR (mate_id = ? AND status IN ?)", current_user.id, current_user.id, [1, 2]).pluck(:mate_id, :user_id).flatten.include?(user.id)
  #   end

  #   # 4. Rassembler les utilisateurs préférés dont la distance entre leur coordonnées est inférieure ou égale à current_user.rayon
  #   users_in_perimeter = []
  #   users_by_preference_not_swiped.each do |mate|
  #     # calculer les distances avec chacun de ces utilisateur
  #     distance = calculate_distance( mate)
  #     if distance <= current_user.search_perimeter
  #       users_in_perimeter << user
  #     end
  #   end

  #   # 5. On vire ceux avec qui on a deja un score de match
  #   @users_without_score = @users_in_perimeter.reject do |user|
  #     user.affinity_scores.keys.include?(current_user.id)
  #   end
  #   # 6. En selectionner 10 au hasard
  #   ten_users = users_without_score.sample(10)

  #   # 7. calculer 10 nouveaux scores à partir des users obtenus
  #   calculate_scores(ten_users)
  # end

  # def calculate_distance(user)
  #   # TODO
  #   # current_user distance avec user
  # end

  # def calculate_scores(users)
  #     # user.API.match_percentage ETC TODO
  # end
end

