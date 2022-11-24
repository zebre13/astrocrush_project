class Affinities
  def create_affinity(user, mate)
    affinity = Affinity.new(user_id: user.id, mate_id: mate.id)
    affinity.report = report(user, mate)
    affinity.score = match_percentage(user, mate)
    affinity.save
  end

  private

  def report(user, mate)
    AstrologyApi.new.partner_report(user.birth_date, user.gender, mate.birth_date, mate.gender, mate.username)
  end

  def match_percentage(user, mate)
    if user.gender == mate.gender
      mate_score_one = AstrologyApi.new.match_percentage(user.birth_date, user.birth_hour, user.latitude, user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
      mate_score_two = AstrologyApi.new.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, user.birth_date, user.birth_hour, user.latitude, user.longitude)
      mate_score_one > mate_score_two ? mate_score_one : mate_score_two
    elsif user.gender == 1
      AstrologyApi.new.match_percentage(user.birth_date, user.birth_hour, user.latitude, user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
    else
      AstrologyApi.new.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, user.birth_date, user.birth_hour, user.latitude, user.longitude)
    end
  end
end
