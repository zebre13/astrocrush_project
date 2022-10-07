class Geocode
  def coordinates(user, ip)
    user.local_lat = latitude(ip)
    user.local_lon = longitude(ip)
  end

  private

  def latitude(ip)
    return Geocoder.search(ip).first.coordinates[0]
  end

  def longitude(ip)
    return Geocoder.search(ip).first.coordinates[0]
  end
end
