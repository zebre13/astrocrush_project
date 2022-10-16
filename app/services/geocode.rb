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
    p user.local_lat, 'this is user.local_lat'
    Geocoder::Calculations.distance_between([user.local_lat, user.local_lon], [mate.local_lat, mate.local_lon], options = {})
  end

  private

  def latitude(ip)
    if Geocoder.search(ip).first.coordinates.any?
      return Geocoder.search(ip).first.coordinates[0]
      # => Geocoder.search("176.160.0.121") ==> 48.8763
    else
      p ip, " ||||||||||||||||       This ip latitude could not be geocoded... ||||||||||||||||||||"
    end
  end

  def longitude(ip)
    return Geocoder.search(ip).first.coordinates[0] if Geocoder.search(ip).first.coordinates.any?
    p ip, "||||||||||||||||           this ip longitude could not be geocoded   ||||||||||||||||"
  end
end
