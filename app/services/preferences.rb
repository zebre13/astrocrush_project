class Preferences
  attr_accessor :array_of_gender_and_age_preferences,
                 :mates_in_perimeter,
                 :reject_mates_with_affinity_score_with_user,
                 :reject_mates_with_too_much_new_affinity_scores_today,
                 :reject_matches
  GEOCODE = Geocode.new
  def self.array_of_gender_and_age_preferences(user, mates)
    p "welcome in array of gender and age preference function. there are currently #{mates.count} mates to calculate"
    mini_date = Date.today - (user.minimal_age * 365)
    max_date = Date.today - (user.maximum_age * 365)
    mates_to_return = mates.select do |mate|
      p "this is user minimum date: #{mini_date}"
      p "this is user max date: #{max_date}"
      p "this is mate birth date: #{mate.birth_date}"
      p " mate birth date <= mini_date ? : #{mate.birth_date <= mini_date}"
      mate.gender == user.looking_for && mate.id != user.id && mate.birth_date <= mini_date && mate.birth_date >= max_date
    end
    p "this is number of mates to return:  #{mates_to_return.count}"
    mates_to_return
  end

  def self.mates_in_perimeter(user, mates)
    mates_in_perimeter = []
    mates.each do |mate|
      distance = GEOCODE.calculate_distance(user, mate)
      p "the distance between user and mate is#{distance} and the search perimeter of user is 20000"
      if distance.round.to_i <= user.search_perimeter
        mates_in_perimeter << mate
      end
    end
    p "there are #{mates_in_perimeter.count} mates in perimeter for #{user.email}"
    mates_in_perimeter

  end

  def self.reject_mates_with_affinity_score_with_user(user, mates)
    mates_without_previous_score = mates.reject do |mate|
      mate.affinity_scores.keys.include?(user.id)
    end
    mates_without_previous_score
  end

  def self.reject_mates_with_too_much_new_affinity_scores_today(mates)
    mates.reject{|mate| mate.new_affinity_scores_today >= 10}
  end

  def self.reject_matches(user, mates)
    users = mates.reject do |user|
      Match.where("(user_id = ?) OR (mate_id = ? AND status IN (1, 2))", user.id, user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
    end
    users
  end
end
