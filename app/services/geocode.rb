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
    # mate_results = Geocoder.search(mate_ip.to_s)



    # Geocoder Github
    distance = ([user.local_lat, user.local_lon]).distance_to([mate.local_lat, mate.local_lon])  # distance from obj to point[lat, lon]
    # OU
    distance = user_loc.distance_to(user_loc)  # distance from obj to point[lat, lon]

    # if obj.geocoded?
    #   obj.nearbys(30)                       # other objects within 30 miles
    #   obj.distance_from([40.714,-100.234])  # distance from arbitrary point to object
    #   obj.bearing_to("Paris, France")       # direction from object to arbitrary point
    # end
  end

  private

  def latitude(ip)
    return Geocoder.search(ip).first.coordinates[0]
  end

  def longitude(ip)
    return Geocoder.search(ip).first.coordinates[0]
  end
end
