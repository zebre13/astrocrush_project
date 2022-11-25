module PreferencesHelper
  def has_affinities?(user)
    genders = user.affinities.map { |affinity| affinity.mate.gender }
    genders.include?(user.looking_for)
  end

  def score(user)
    current_user.affinities.find_by(mate_id: user).score
  end
end
