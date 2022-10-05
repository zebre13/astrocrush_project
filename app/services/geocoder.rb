class Geocoder
  def set_latitude
    return Geocoder.search(request.remote_ip).first.coordinates[0]
  end

  def set_longitude
    return Geocoder.search(request.remote_ip).first.coordinates[0]
  end
end
