class Affinities
  def partner_report(user, mate)
    mate_partner_report = AstrologyApi.new.partner_report(user.birth_date, user.gender, mate.birth_date, mate.gender, mate.username)
    mate_partner_report_fr = mate_partner_report.transform_values { |item| Translation.new.to_fr(item).text }
    mate.partner_reports.store(user.id, mate_partner_report_fr)
    mate.save!
    user.partner_reports.store(mate.id, mate_partner_report_fr)
    user.save!
  end

  def match_percentage(user, mate)
    if user.gender == mate.gender
      mate_score_one = AstrologyApi.new.match_percentage(user.birth_date, user.birth_hour, user.latitude, user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
      mate_score_two = AstrologyApi.new.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, user.birth_date, user.birth_hour, user.latitude, user.longitude)
      mate_score_one > mate_score_two ? mate_score = mate_score_one : mate_score = mate_score_two
    elsif user.gender == 1
      mate_score = AstrologyApi.new.match_percentage(user.birth_date, user.birth_hour, user.latitude, user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
    else
      mate_score = AstrologyApi.new.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, user.birth_date, user.birth_hour, user.latitude, user.longitude)
    end
    mate.affinity_scores.store(user.id, mate_score)
    mate.new_affinity_scores_today += 1
    mate.save!
    user.affinity_scores.store(mate.id, mate_score)
    user.new_affinity_scores_today += 1
    user.save!
    p 'affinity calculated (maybe)'
  end
end
