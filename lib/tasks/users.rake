namespace :users do
  desc "Update all users score"
  task update_all: :environment do
    UpdateUserJob.perform_later
  end

  desc "Update all users score"
  task distance: :environment do
    first = User.first
    last = User.last

    distance = Geocode.haversine_distance(first, last, miles: false)
    p distance
  end
end
