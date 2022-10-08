class Preferences
  def array_of_gender_and_age_preferences(user)
    mini_date = Date.today - (user.minimal_age * 365)
    max_date = Date.today - (user.maximum_age * 365)
    User.where(gender: user.looking_for).where.not(id: user.id).where("(birth_date < ?)", mini_date).where("(birth_date > ?)", max_date)
  end

  def mates_in_perimeter(user, mates)
    mates_in_perimeter = []
    mates.each do |mate|
      users_in_perimeter << mate if GEOCODE.calculate_distance(user, mate) <= user.search_perimeter
    end
    mates_in_perimeter
  end
end
