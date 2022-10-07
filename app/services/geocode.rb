class Geocode
  def coordinates(user, ip)
    user.local_lat = latitude(ip)
    user.local_lon = longitude(ip)
  end

  def calculate_distance(user, mate)
    user_ip = user.last_sign_in_ip
    mate_ip = mate.last_sign_in_ip
    coordinates(user, user_ip.to_s)
    coordinates(mate, mate_ip.to_s)
    Geocoder::Calculations.distance_between(loc1, loc2, options = {})
  end

  private

  def latitude(ip)
    return Geocoder.search(ip).first.coordinates[0]
  end

  def longitude(ip)
    return Geocoder.search(ip).first.coordinates[0]
  end
end
