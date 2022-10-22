class Geocode
  attr_reader :coordinates
  def coordinates(user)
    #  Assigne local_lon et local_lat
    p user.last_sign_in_ip
    data = Geocoder.search(user.last_sign_in_ip.to_s).first.coordinates
    p data, "this is data"
    user.local_lat = data[0]
    user.local_lon = data[1]
    p user.local_lat
    p user.local_lon
  end


  def calculate_distance(user, mate)
    coordinates(mate)
    distance = Geocoder::Calculations.distance_between([user.local_lat, user.local_lon], [mate.local_lat, mate.local_lon], options = {})
    p distance
    return distance
  end


  def latitude(ip)

    Geocoder.search(ip).first.coordinates[0]

  end

  def longitude(ip)
    return Geocoder.search(ip).first.coordinates[1]
  end
end
