class Preferences
  attr_accessor :array_of_gender_and_age_preferences,
                 :mates_in_perimeter,
                 :reject_mates_with_affinity_score_with_user,
                 :reject_mates_with_too_much_new_affinity_scores_today,
                 :reject_matches
  GEOCODE = Geocode.new
  def self.fits_gender_and_age_preferences?(user, mate)
    p 'welcome in fits_gender_and_age'
    mini_date = Date.today - (user.minimal_age * 365)
    p # TODO mini_date
    max_date = Date.today - (user.maximum_age * 365)
    return mate.gender == user.looking_for && mate.id != user.id && mate.birth_date >= mini_date && mate.birth_date <= max_date
  end

  def self.mate_in_perimeter?(user, mate)
    distance = GEOCODE.calculate_distance(user, mate)
    !distance.nil? && distance.round.to_i <= user.search_perimeter
  end

  def self.affinity_score_with_user(user, mate)
    mate.affinity_scores.keys.include?(user.id)
  end

  def self.reject_mates_with_too_much_new_affinity_scores_today(mates)
    mates.reject{|mate| mate.new_affinity_scores_today >= 10}
  end

  def self.has_matched_with_user?(user, mate)
    Match.where("(user_id = ?) OR (mate_id = ? AND status IN (1, 2))", user.id, user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
  end
end
