class Preferences
  attr_accessor :array_of_gender_and_age_preferences,
                 :mates_in_perimeter,
                 :reject_mates_with_affinity_score_with_user,
                 :reject_mates_with_too_much_new_affinity_scores_today,
                 :reject_matches
  GEOCODE = Geocode.new
  def self.array_of_gender_and_age_preferences(user)
    mini_date = Date.today - (user.minimal_age * 365)
    max_date = Date.today - (user.maximum_age * 365)
    User.where(gender: user.looking_for).where.not(id: user.id).where("(birth_date < ?)", mini_date).where("(birth_date > ?)", max_date)
  end

  def self.mates_in_perimeter(user, mates)
    mates_in_perimeter = []
    mates.each do |mate|
      p GEOCODE.calculate_distance(user, mate)
      if (GEOCODE.calculate_distance(user, mate).to_i  <= user.search_perimeter)
        mates_in_perimeter << mate
      end
    end
    mates_in_perimeter
  end

  def self.reject_mates_with_affinity_score_with_user(user, mates)
    mates_without_previous_score = mates.reject do |mate|
      mate.affinity_scores.keys.include?(user.id)
    end
    mates_without_previous_score
  end

  def reject_mates_with_too_much_new_affinity_scores_today(mates)
    mates.reject{|mate| mate.new_affinity_scores_today >= 10}
  end

  def reject_matches(user, mates)
    users = mates.reject do |user|
      Match.where("(user_id = ?) OR (mate_id = ? AND status IN (1, 2))", user.id, user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
    end
    users
  end
end
