module ProfileHelper
  def create_astroprofil
    return unless user_signed_in?

    Astroprofil.profil(current_user)
  end

  def create_affinities(number)
    return unless user_signed_in?

    mates_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id).sample(number)
    mates_by_gender.each { |mate| Affinities.new.create_affinity(current_user, mate) }
  end

  def mini_date
    Date.today - (current_user.minimal_age * 365)
  end

  def max_date
    Date.today - (current_user.maximum_age * 365)
  end
end
