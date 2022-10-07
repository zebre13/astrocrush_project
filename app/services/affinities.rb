require_relative 'astrology_api'

class Affinities
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])


  def partner_report(user, mates)
    partner_report_collection = {}
    mates.each do |mate|
      mate_partner_report = API_CALL.partner_report(user.birth_date, user.gender, mate.birth_date, mate.gender, mate.username)
      partner_report_collection.store(mate.id, mate_partner_report)
      mate.partner_reports.store(user.id, mate_score)
    end
    user.partner_reports = partner_report_collection
    user.save!
  end

  def sign_report(user, mates)
    sun_report_collection = {}
    mates.each do |mate|
      mate_sun_report = API_CALL.sign_report(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude,'sun')
      sun_report_collection.store(mate.id, mate_sun_report)
      mate.mate_sun_reports.store(user.id, mate_score)
    end
    user.mate_sun_reports = sun_report_collection
    user.save!
  end

  def match_percentage(user, mates)
    score_collection = {}
    mates.each do |mate|
      if user.gender == mate.gender
        mate_score_one = API_CALL.match_percentage(user.birth_date, user.birth_hour, user.latitude, user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
        mate_score_two = API_CALL.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, user.birth_date, user.birth_hour, user.latitude, user.longitude)
        mate_score_one > mate_score_two ? mate_score = mate_score_one : mate_score = mate_score_two
      elsif user.gender == 1
        mate_score = API_CALL.match_percentage(user.birth_date, user.birth_hour, user.latitude, user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
      else
        mate_score = API_CALL.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, user.birth_date, user.birth_hour, user.latitude, user.longitude)
      end
      score_collection.store(mate.id, mate_score)
      mate.affinity_scores.store(user.id, mate_score)
    end
    ordered_score_collection = score_collection.sort_by { |_id, score| score }
    user.affinity_scores = ordered_score_collection.reverse.to_h
    user.save!
  end
end
