require_relative '../services/affinities'
require_relative '../services/astrology_api'
require_relative '../services/astroprofil'
require_relative '../services/geocode'
require_relative '../services/preferences'

class UpdateUserJob < ApplicationJob
  queue_as :default

  # cronjob pour lancer tous les 24 heures, sur heroku


  def perform
    # TODO : implémenter la réccurence une fois par jour, mais d'abord pouvoir le faire sur commande.
    users = User.all
    # Set le nombre de nouveaux affinity scores quotidien à 0 dans une boucle séparée.
    users.each { |user| user.new_affinity_scores_today = 0 }

    # Calculer des nouveaux scores pour tout le monde
    users.each do |user|
      # Calculer le nombre d'affinity scores à calculer pour l'user en question
      number_of_scores_to_calculate = 10 - user.new_affinity_scores_today

      # Updater l'index de cet user si son nombre de scores de match à calculer est positif (sinon il est chanceux)
      update_index(user, number_of_scores_to_calculate) if number_of_scores_to_calculate.positive?
    end
  end

  def update_index(user, number_of_scores_to_calculate)

    # Mates du bon age et genre
    potential_mates = PREFERENCES.array_of_gender_and_age_preferences(user)

    # Filtre de ceux dans le périmetre
    mates_in_perimeter = PREFERENCES.mates_in_perimeter(user, potential_mates)

    # Selectionner pour ensuite rejeter les utilisateurs qui ont un score de match calculé avec moi
    mates_without_score = PREFERENCES.reject_mates_with_affinity_score_with_user(user, mates_in_perimeter)

    # On rejette tous les users qui sont dans les matchs du current user
    mates_already_matched = PREFERENCES.reject_matches(user, mates_without_score)

    # On rejette tous ceux qui ont eu plus de 10 nouveaux scores aujourd'hui et on en prend n
    n_mates = reject_mates_with_too_much_new_affinity_scores_today(mates_already_matched).sample(number_of_scores_to_calculate)

    # Calculer l'affinity scores avec ces ten_user
    AFFINITIES.match_percentage(user, n_mates)

    # Màj le nombre de nouveaux affinity_scores de chacun des n_mates
    n_mates.each{ |mate| mate.new_affinity_scores_today += 1 }

  end

end
