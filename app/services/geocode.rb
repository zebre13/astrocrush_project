class Geocode

  def coordinates(user)
    #  Assigne local_lon et local_lat
    p user.last_sign_in_ip
    data = Geocoder.search(user.last_sign_in_ip.to_s).first.coordinates
    p data, "this is data"
    user.local_lat = data[0]
    user.local_lon = data[1]
    p "=> #{user.local_lat}<= is user local_lat "
    p "=> #{user.local_lon}<= is user local_lon "
    user.coordinates_updated_today = true
    user.save!
  end

  def calculate_distance(user, mate)
    coordinates(mate) unless mate.coordinates_updated_today == true
    distance = Geocoder::Calculations.distance_between([user.local_lat, user.local_lon], [mate.local_lat, mate.local_lon], options = {})
    p "=> #{distance} <= km  betwen user #{user.id} and mate #{mate.id}"
    return distance unless distance.nil?
  end

  def haversine_distance(lat_a, lon_a, lat_b, lon_b, miles: false)
    # TODO
    d_lat = (lat_b - lat_a) * Math::PI / 180
    d_lon = (lon_b - lon_a) * Math::PI / 180

    a = Math.sin(d_lat / 2) *
        Math.sin(d_lat / 2) +
        Math.cos(lat1 * Math::PI / 180) *
        Math.cos(lat2 * Math::PI / 180) *
        Math.sin(d_lon / 2) * Math.sin(d_lon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    return 6371 * c * (miles ? 1 / 1.6 : 1)
  end

  # private

  # def latitude(ip)
  #   Geocoder.search(ip).first.coordinates[0]
  # end

  # def longitude(ip)
  #   return Geocoder.search(ip).first.coordinates[1]
  # end
end
