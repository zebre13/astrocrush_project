module ProfileHelper
  def create_astroprofil
    return unless user_signed_in?

    Astroprofil.new.profil(current_user)
  end

  def create_affinities(number)
    return unless user_signed_in?

    mates_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id).sample(number)
    mates_by_gender.each { |mate| affinities(current_user, mate) }
  end

  def affinities(user, mate)
    Affinities.new.partner_report(user, mate)
    Affinities.new.match_percentage(user, mate)
  end
end
