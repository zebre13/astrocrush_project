class UsersController < ApplicationController
  before_action :set_user, only: %i[update edit_infos edit_password]

  ZODIAC = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
  LOGOS = { Ascendant: "↑", Sun: "☉", Moon: "☽", Mercury: "☿", Venus: "♀︎", Mars: "♂︎", Jupiter: "♃", Saturn: "♄", Uranus: "♅", Neptune: "♆", Pluto: "♇" }

  def show
    @mate = User.find(params[:id])
    @mate_sun_report = I18n.t "planets_in_signs.Sun.#{@mate.sign.to_sym}"
  end

  def index
    if !current_user.birth_date
      redirect_to birth_date_path
    else
      users_by_preference = User.where(gender: current_user.looking_for).where.not(id: current_user.id).where("(birth_date < ?)", helpers.mini_date).where("(birth_date > ?)", helpers.max_date)

      users_with_score = users_by_preference.select do |user|
        user.affinity_scores.keys.include?(current_user.id)
      end

      @users = users_with_score.reject do |user|
        Match.where("(user_id = ?) OR (mate_id = ? AND status IN (1, 2))", current_user.id, current_user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
      end
    end
  end

  def update
    case params[:commit]
    when "Calculer mon Astroprofil"
      if @user.update(user_params("birth_date"))
        helpers.create_affinities(10)
        helpers.create_astroprofil
        flash[:notice] = t("activerecord.valid.messages.success")
        redirect_to dashboard_path
      else
        flash[:alert] = t("activerecord.#{params[:user][:page]}.errors.messages.error_has_occured")
      end
    when "Editer mes infos"
      if @user.update(user_params("edit_infos"))
        helpers.create_affinities(10) if User.find(@user.affinity_scores.first.first).gender != @user.looking_for
        redirect_to dashboard_path
      else
        flash[:alert] = t("activerecord.#{params[:user][:page]}.errors.messages.error_has_occured")
      end
    when "Modifier mon mot de passe"
      if @user.update(user_params("edit_password"))
        redirect_to dashboard_path
      else
        flash[:alert] = t("activerecord.#{params[:user][:page]}.errors.messages.error_has_occured")
      end
    end
  end

  def edit_infos
    if !current_user.birth_date
      redirect_to birth_date_path
    end
  end

  def edit_password
    if !current_user.birth_date
      redirect_to birth_date_path
    end
  end

  def birth_date
    @user = current_user
  end

  def astroboard
    if !current_user.birth_date
      redirect_to birth_date_path
    else
      @daily_horoscope = Translation.new.to_fr(AstrologyApi.new.daily_horoscope(current_user.sign)).text
      @zodiac_compatibility = AstrologyApi.new.zodiac_compatibility(current_user.sign)
      @my_signs = my_signs(current_user.horoscope_data)
      @my_planets = my_planets_with_logos(current_user.horoscope_data)
      @my_houses = my_houses(current_user.horoscope_data)
    end
  end

  private

  def set_user
    @user = current_user
  end

  # Array of sorted planets used for the construction of the astroboard table
  def my_planets(horoscope_data)
    planets = {}
    horoscope_data["planets"].first(10).each { |data| planets[data["name"]] = data["full_degree"] }
    asc_d = horoscope_data["ascendant"]
    adj_planets = planets.transform_values { |d| d <= asc_d ? (d - asc_d + 360) : (d - asc_d) }
    ordered_planets = adj_planets.sort_by { |_key, value| value }.to_h
    ordered_planets.keys.unshift "Ascendant"
  end

  # Array of sorted planets with logos used for display in the astroboard table
  def my_planets_with_logos(horoscope_data)
    my_planets = my_planets(horoscope_data)
    my_planets.map { |planet| [LOGOS[planet.to_sym], planet] }
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
    signs.slice_when { |i, j| i != j }.to_a
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
    houses.group_by{ |x| x }.values
  end


  def user_params(step)
    permitted_attributes = case step
                           when "birth_date"
                             %i[birth_date birth_hour birth_location latitude longitude gender looking_for country city utcoffset]
                           when "edit_infos"
                             [:username, :description, :photos, :minimal_age, :maximum_age, :search_perimeter, :looking_for, photos: []]
                           when "edit_password"
                             [:password]
                           end
    params.require(:user).permit(permitted_attributes)
  end
end
