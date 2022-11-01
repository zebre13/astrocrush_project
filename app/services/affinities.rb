class Affinities
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])


  def partner_report(user, mate)
    mate_partner_report = API_CALL.partner_report(user.birth_date, user.gender, mate.birth_date, mate.gender, mate.username)
    mate.partner_reports.store(user.id, mate_partner_report)
    mate.save!
    user.partner_reports.store(mate.id, mate_partner_report)
    user.save!
  end

  def match_percentage(user, mate)
    if user.gender == mate.gender
      mate_score_one = API_CALL.match_percentage(user.birth_date, user.birth_hour, user.latitude, user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
      mate_score_two = API_CALL.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, user.birth_date, user.birth_hour, user.latitude, user.longitude)
      mate_score_one > mate_score_two ? mate_score = mate_score_one : mate_score = mate_score_two
    elsif user.gender == 1
      mate_score = API_CALL.match_percentage(user.birth_date, user.birth_hour, user.latitude, user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
    else
      mate_score = API_CALL.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, user.birth_date, user.birth_hour, user.latitude, user.longitude)
    end
    mate.affinity_scores.store(user.id, mate_score)
    mate.save!
    user.affinity_scores.store(mate.id, mate_score)
    user.save!
  end
end
