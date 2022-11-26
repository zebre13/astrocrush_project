class Geocode
  def self.coordinates(user)
    coordinates = Geocoder.search(user.last_sign_in_ip.to_s).first.coordinates
    user.local_lat = coordinates[0]
    user.local_lon = coordinates[1]
    user.coordinates_updated_today = true
    user.save!
  end

  def self.haversine_distance(user, mate, miles: false)
    if user.local_lon && user.local_lat && mate.local_lat && mate.local_lon
      d_lat = (mate.local_lat - user.local_lat) * Math::PI / 180
      d_lon = (mate.local_lon - user.local_lon) * Math::PI / 180

      a = (Math.sin(d_lat / 2) *
      Math.sin(d_lat / 2) +
      Math.cos(user.local_lat * Math::PI / 180) *
      Math.cos(mate.local_lat * Math::PI / 180) *
      Math.sin(d_lon / 2) * Math.sin(d_lon / 2))
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

      6371 * c * (miles ? 1 / 1.6 : 1)
    end
  end
  # def self.calculate_distance(user, mate)
  #   coordinates(mate) unless mate.coordinates_updated_today == true
  #   distance = Geocoder::Calculations.distance_between([user.local_lat, user.local_lon], [mate.local_lat, mate.local_lon], options = {})
  #   p "=> #{distance} <= km  betwen user #{user.id} and mate #{mate.id}"
  #   return distance unless distance.nil?
  # end
end
