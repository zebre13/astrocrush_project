class UsersController < ApplicationController
  before_action :set_user, only: %i[update onboarding_birth onboarding_profil edit_infos edit_password]
  after_action :create_astroprofil, only: %i[onboarding_birth]
  after_action :create_ten_affinities, only: %i[onboarding_birth]

  ZODIAC = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
  LOGOS = { Ascendant: "↑", Sun: "☉", Moon: "☽", Mercury: "☿", Venus: "♀︎", Mars: "♂︎", Jupiter: "♃", Saturn: "♄", Uranus: "♅", Neptune: "♆", Pluto: "♇" }

  def show
    @mate = User.find(params[:id])
    @mate_sun_report = I18n.t "planets_in_signs.Sun.#{@mate.sign.to_sym}"
  end

  def index
    users_by_preference = User.where(gender: current_user.looking_for).where.not(id: current_user.id).where("(birth_date < ?)", mini_date).where("(birth_date > ?)", max_date)

    users_with_score = users_by_preference.select do |user|
      user.affinity_scores.keys.include?(current_user.id)
    end

    @users = users_with_score.reject do |user|
      Match.where("(user_id = ?) OR (mate_id = ? AND status IN (1, 2))", current_user.id, current_user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = t("activerecord.valid.messages.success")
    else
      flash[:alert] = t("activerecord.#{params[:user][:page]}.errors.messages.error_has_occured")
    end
    # redirect(params[:user][:page])
  end

  def onboarding_birth
    render :onboarding_birth
  end

  def onboarding_profil
    render :onboarding_profil
  end

  def edit_infos
    render :edit_infos
  end

  def edit_password
    render :edit_password
  end

  def astroboard
    @daily_horoscope = AstrologyApi.new.daily_horoscope(current_user.sign)
    @zodiac_compatibility = AstrologyApi.new.zodiac_compatibility(current_user.sign)
    @my_signs = my_signs(current_user.horoscope_data)
    @my_planets = my_planets_with_logos(current_user.horoscope_data)
    @my_houses = my_houses(current_user.horoscope_data)
  end

  private

  def set_user
    @user = current_user
  end

  def mini_date
    Date.today - (current_user.minimal_age * 365)
  end

  def max_date
    Date.today - (current_user.maximum_age * 365)
  end


  def create_astroprofil
    return unless user_signed_in?

    Astroprofil.new.profil(current_user)
  end

  def create_ten_affinities
    return unless user_signed_in?

    mates_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id).sample(10)
    mates_by_gender.each { |mate| affinities(current_user, mate) }
  end

  def affinities(user, mate)
    Affinities.new.partner_report(user, mate)
    Affinities.new.match_percentage(user, mate)
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

  def user_params
    params.require(:user).permit(:birth_date, :birth_hour, :birth_location, :latitude, :longitude, :gender, :looking_for)
  end

  def redirect(page)
    if page == "onboarding_birthdate"
      redirect_to main_interests_path
    else
      redirect_back fallback_location: root_path
    end
  end
end
