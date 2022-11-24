class Affinities
  def create_affinity(user, mate)
    affinity = Affinity.new(user_id: user.id, mate_id: mate.id)

    report(user, mate, affinity)

    affinity.score = match_percentage(user, mate)
    affinity.save
  end

  private

  def report(user, mate, affinity)
    response = AstrologyApi.new.partner_report(user.birth_date, user.gender, mate.birth_date, mate.gender, mate.username).to_s.gsub('=>', ':')
    hash = JSON.parse response
    report = Report.new(title: hash['title'], msg: hash['msg'], tags: hash['tags'], affinity_id: affinity.id)
    report.save
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
