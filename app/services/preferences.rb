class Preferences
  def self.fits_gender_and_age?(user, mate)
    mini_date = Date.today - (user.minimal_age * 365)
    max_date = Date.today - (user.maximum_age * 365)
    mate.gender == user.looking_for && mate.id != user.id && mate.birth_date <= mini_date && mate.birth_date >= max_date
  end

  def self.affinity_with_user?(user, mate)
    mate.affinities.find_by(mate_id: user.id) || mate.affinities.find_by(user_id: user.id)
  end

  def self.match_with_user?(user, mate)
    matches = user.matches.select do |match|
      match.user_id == mate.id || match.mate_id == mate.id
    end
    matches.count.positive?
  end

  def self.mate_in_perimeter?(user, mate)
    Geocode.haversine_distance(user, mate) <= user.search_perimeter
  end
end
