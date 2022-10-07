require_relative '../../../app/services/astrology_api'

class Affinities
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])


  def partner_report(mates)
    partner_report_collection = {}
    mates.each do |mate|
      mate_partner_report = API_CALL.partner_report(current_user.birth_date, current_user.gender, mate.birth_date, mate.gender, mate.username)
      partner_report_collection.store(mate.id, mate_partner_report)
      mate.partner_reports.store(current_user.id, mate_score)
    end
    current_user.partner_reports = partner_report_collection
    mate.save!
  end

  def sun_reports(mates)
    sun_report_collection = {}
    mates.each do |mate|
      mate_sun_report = API_CALL.sign_report(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude,'sun')
      sun_report_collection.store(mate.id, mate_sun_report)
      mate.mate_sun_reports.store(current_user.id, mate_score)
    end
    current_user.mate_sun_reports = sun_report_collection
    mate.save!
  end

  def match_percentage(mates)
    score_collection = {}
    mates.each do |mate|
      if current_user.gender == mate.gender
        mate_score_one = API_CALL.match_percentage(current_user.birth_date, current_user.birth_hour, current_user.latitude, current_user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
        mate_score_two = API_CALL.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, current_user.birth_date, current_user.birth_hour, current_user.latitude, current_user.longitude)
        mate_score_one > mate_score_two ? mate_score = mate_score_one : mate_score = mate_score_two
      elsif current_user.gender == 1
        mate_score = API_CALL.match_percentage(current_user.birth_date, current_user.birth_hour, current_user.latitude, current_user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
      else
        mate_score = API_CALL.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, current_user.birth_date, current_user.birth_hour, current_user.latitude, current_user.longitude)
      end
      score_collection.store(mate.id, mate_score)
      mate.affinity_scores.store(current_user.id, mate_score)
    end
    ordered_score_collection = score_collection.sort_by { |_id, score| score }
    current_user.affinity_scores = ordered_score_collection.reverse.to_h
    current_user.save!
  end
end
