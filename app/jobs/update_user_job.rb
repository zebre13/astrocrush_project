require_relative '../services/affinities'
require_relative '../services/astrology_api'
require_relative '../services/astroprofil'
require_relative '../services/geocode'
require_relative '../services/preferences'

class UpdateUserJob < ApplicationJob
  queue_as :default
  require 'preferences'
  require 'affinities'
  require 'geocode'
  # cronjob pour lancer tous les 24 heures, sur heroku
  PREFERENCE = Preferences.new
  AFFINITIES = Affinities.new
  GEOCODE = Geocode.new


  def perform
    # Changer le nombre de tranche de saucisson  et de maximum d'affinity scores du jour a la demande
    tranches = 11
    max_count = 3

    # Pour chaque user, met les new_affinity_scores à 0 et coordinates_updated_today à false
    users = User.last(2)
    initialize_update(users)

    # Pour l'update de l'index de chaque users
    users.each do |user|
      # Saucissoner l'array de mates en "11" (  2 boudins la )
      mates = User.all.shuffle.each_slice(tranches).to_a
      # (re)mettre i à 0
      i = 0
      # Pour chaque user, jusqu'a ce que son nombre de scores passe à 3 ou que i == mates.count -1, faire ça :
      until user.new_affinity_scores_today == max_count || i == (mates.count - 1)
        # itérer sur chacun des array mates[i]
        mates[i].each do |mate|
          # binding.pry
          # Sortir de cette boucle si l'utilisateur a atteint son nombre de max count avant la fin du premier array
          break if user.new_affinity_scores_today >= max_count

          p "user new affinity scores today = #{user.new_affinity_scores_today}"
          # nexter sauf si mate du bon age et du bon sexe ?
          # binding.pry
          next unless Preferences.fits_gender_and_age_preferences?(user, mate)

          p "user fits gender and age"
          # nexter si y'a un affinity score avec user
          next if Preferences.affinity_score_with_user?(user, mate)

          p "user and mate don't have affinity scores already"
          # Rejeter les mates qui ont déja un match avec moi
          next if Preferences.has_matched_with_user?(user, mate)

          p "user hasn't match with user yet"
          # Rejeter le mate qui ont déja 10 new affinity-scores_today
          next if mate.new_affinity_scores_today >= max_count

          p "mate has not yet reached his maximum affinity count for today"
          # Calculer coordonées du jour du user sauf si elles ont déja été calculées aujourd'hui
          GEOCODE.coordinates(user) unless user.coordinates_updated_today == true

          p "let's calculate affinities now"
          # Si le mate est dans le périmetre, calculer le match percentage
          AFFINITIES.match_percentage(user, mate) if Preferences.mate_in_perimeter?(user, mate)
          p "lets jump to next mate to potentially calculate affinity with!"
        end
        p "saucisson '#{i} parsed, user has #{user.new_affinity_scores_today} new affinity scores so far "
        i += 1
      end
    end
  end

  private

  def initialize_update(users)
    # Initialiser les paramètres
    p "Initializing parameters"
    users.each do |user|
      user.new_affinity_scores_today = 0
      user.coordinates_updated_today = false
      user.save!
    end
    p "Parameters initialized successfully"

  end
end

  # Calculer des nouveaux scores pour tout le monde
  #   users.each do |user|
  #     # Calculer le nombre d'affinity scores à calculer pour l'user en question
  #     number_of_scores_to_calculate = 10 - user.new_affinity_scores_today

  #     # Updater l'index de cet user si son nombre de scores de match à calculer est positif (sinon il est chanceux)
  #     update_index(user, number_of_scores_to_calculate) if number_of_scores_to_calculate.positive?
  #     p "updated index for #{user.email}"
  #     user.save
  #   end
  #   b = Time.now
  #   c = b - a
  #   p c, 'this is time that the job took to perform'
  # end

  # def update_index(user, number_of_scores_to_calculate)
  #   # Mates du bon age et genre
  #   potential_mates = Preferences.array_of_gender_and_age_preferences(user)
  #   p potential_mates.count, "this is potential_mates.count"

  #   # Filtre de ceux dans le périmetre
  #   mates_in_perimeter = Preferences.mates_in_perimeter(user, potential_mates)
  #   p mates_in_perimeter.count, "this is mates in perimeter.count for #{user.email}"

  #   # Selectionner pour ensuite rejeter les utilisateurs qui ont un score de match calculé avec moi
  #   mates_without_score = Preferences.reject_mates_with_affinity_score_with_user(user, mates_in_perimeter)

  #   # On rejette tous les users qui sont dans les matchs du current user
  #   mates_already_matched = Preferences.reject_matches(user, mates_without_score)

  #   # On rejette tous ceux qui ont eu plus de 10 nouveaux scores aujourd'hui et on en prend n
  #   n_mates = Preferences.reject_mates_with_too_much_new_affinity_scores_today(mates_already_matched).sample(number_of_scores_to_calculate)

  #   # Calculer l'affinity scores avec ces ten_user
  #   AFFINITIES.match_percentage(user, n_mates)

  #   # Màj le nombre de nouveaux affinity_scores de chacun des n_mates mais aussi du user
  #   n_mates.each{ |mate| mate.new_affinity_scores_today += 1 }

  #   # Màj le nombre de nouveaux affinity scores pour l'user également
  #   user.new_affinity_scores_today += 1

  # end
