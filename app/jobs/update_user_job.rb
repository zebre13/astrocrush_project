require_relative '../services/affinities'
require_relative '../services/astrology_api'
require_relative '../services/astroprofil'
require_relative '../services/geocode'
require_relative '../services/preferences'

class UpdateUserJob < ApplicationJob
  queue_as :default
  require 'preferences.rb'
  require 'affinities.rb'
  # cronjob pour lancer tous les 24 heures, sur heroku
  PREFERENCE = Preferences.new
  AFFINITIES = Affinities.new


  def perform
    # TODO : implémenter la réccurence une fois par jour, mais d'abord pouvoir le faire sur commande.
    # users = User.all
    user = User.first
    mates = User.all.shuffle.each_slice(2).to_a
    i = 0
    user.new_affinity_scores_today = 0

    until user.new_affinity_scores_today == 2 || mates[i].nil?ù
      # selectionner ceux du bon age et sexe
      p mates[i], "this is mates[#{i}]"
      mates_with_right_gender_and_age = Preferences.array_of_gender_and_age_preferences(user, mates[i]) unless mates[i].nil?

      # Rejeter ceux avec un score de match préexistant avec moi
      mates_without_score = Preferences.reject_mates_with_affinity_score_with_user(user, mates_with_right_gender_and_age)

      # Rejeter les mates qui ont déja un match avec moi
      mates_without_match_with_me = Preferences.reject_matches(user, mates_without_score)

      # Rejeter les mates qui ont déja 10 new affinity-scores_today
      potential_mates = Preferences.reject_mates_with_too_much_new_affinity_scores_today(mates_without_match_with_me)

      # Calculer ceux dans le périmètre
      mates_in_perimeter = Preferences.mates_in_perimeter(user, potential_mates)

      # A moins que mates_in_perimeter soit vide, calculer le score de match avec ces mates et incrémenter new affinity_scores_today a chaque fois
      AFFINITIES.match_percentage(user, mates_in_perimeter) unless mates_in_perimeter.empty?
      i += 1 unless mates[i].nil?
    end
    puts 'bye '
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
