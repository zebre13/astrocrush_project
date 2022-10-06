module ApplicationHelper
  def embedded_svg(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end

  def define_coordinates(user)
    user.local_lat = Geocoder.search(request.remote_ip).first.coordinates[0]
    user.local_lon = Geocoder.search(request.remote_ip).first.coordinates[1]
  end

end
