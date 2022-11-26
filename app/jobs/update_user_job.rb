class UpdateUserJob < ApplicationJob
  queue_as :default

  def perform
    slices = 10
    max_count = 10
    users = User.all

    users.each do |user|
      p "///////////////////////////////////"
      p "///////////////////////////////////"
      p "#{user.username} is being updated"
      # Geocode.coordinates(user) if user.last_sign_in_at > Date.today - 1

      mates_slices = User.all.where.not(id: user.id).shuffle.each_slice(slices).to_a
      i = 0
      until user.affinities.count == max_count || i == (mates_slices.count - 1)
        mates_slices[i].each do |mate|
          p "///////////////////////////////////////////"
          p "0 // comparing with #{mate.username}"
          break if user.affinities.count > max_count || mate.affinities.count > max_count
          p "1 // affinities count is less than max_count"
          break unless Preferences.fits_gender_and_age?(user, mate)
          p "2 // correspond to #{user.username}'s gender and age preferences"
          break if Preferences.affinity_with_user?(user, mate)
          p "3 // has no affinity with  #{user.username}"
          break if Preferences.match_with_user?(user, mate)
          p "4 // has no match with #{user.username}"
          break unless Preferences.mate_in_perimeter?(user, mate)
          p "5 // is in #{user.username} perimeter"

          p "BINGO PASSED ALL ETAPES"

          Affinities.new.create_affinity(user, mate)
        end
        p " #{i} parsed, user has #{user.affinities.count} new affinity scores so far "
        i += 1
      end
    end
  end
end
