class UpdateUserJob < ApplicationJob
  queue_as :default

  def perform
    slices = 11
    max_count = 3

    users = User.all
    initialize_update(users)

    users.each do |user|
      mates = User.all.shuffle.each_slice(slices).to_a
      i = 0
      until user.new_affinity_scores_today == max_count || i == (mates.count - 1)
        mates[i].each do |mate|
          break if user.new_affinity_scores_today >= max_count
          next unless Preferences.fits_gender_and_age_preferences?(user, mate)
          next if Preferences.affinity_score_with_user?(user, mate)
          next if Preferences.has_matched_with_user?(user, mate)
          next if mate.new_affinity_scores_today >= max_count

          Geocode.new.coordinates(user) unless user.coordinates_updated_today == true
          Affinities.new.match_percentage(user, mate) if Preferences.mate_in_perimeter?(user, mate)
        end
        i += 1
      end
    end
  end

  private

  def initialize_update(users)
    p "Initializing parameters"
    users.each do |user|
      user.new_affinity_scores_today = 0
      user.coordinates_updated_today = false
      user.save!
    end
    p "Parameters initialized successfully"

  end
end
