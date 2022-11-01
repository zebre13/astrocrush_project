require_relative '../services/affinities'
require_relative '../services/astrology_api'
require_relative '../services/astroprofil'
require_relative '../services/geocode'
require_relative '../services/preferences'

class UpdateUserJob < ApplicationJob
  queue_as :default
  require 'preferences.rb'
  require 'affinities.rb'
  require 'geocode.rb'
  # cronjob pour lancer tous les 24 heures, sur heroku
  PREFERENCE = Preferences.new
  AFFINITIES = Affinities.new
  GEOCODE = Geocode.new
<<<<<<< HEAD


  def perform
    # Changer le nombre de tranche de saucisson  et de maximum d'affinity scores du jour a la demande
    tranches = 11
    max_count = 3

    # Pour chaque user, met les new_affinity_scores à 0 et coordinates_updated_today à false
    users = User.all
    initialize_update(users)

    # Pour l'update de l'index de chaque users
    users.each do |user|
      # Saucissoner l'array de mates en "11" (  2 boudins la )
      mates = User.all.shuffle.each_slice(tranches).to_a
      # (re)mettre i à 0
      i = 0
      # Pour chaque user, jusqu'a ce que son nombre de scores passe à 3 ou que i == mates.count -1, faire ça :
      until user.new_affinity_scores_today == max_count || i == mates.count
        # itérer sur chacun des array mates[i]
        mates[i].each do |mate|
          # Sortir de cette boucle si l'utilisateur a atteint son nombre de max count avant la fin du premier array
          break if user.new_affinity_scores_today == max_count
          # nexter sauf si mate du bon age et du bon sexe ?
          next unless PREFERENCE.fits_gender_and_age_preferences?(user, mate)
          # nexter si y'a un affinity score avec user
          next if PREFERENCE.affinity_score_with_user?(user, mate)
          # Rejeter les mates qui ont déja un match avec moi
          next if PREFERENCE.has_matched_with_user?(user, mate)
          # Rejeter le mate qui ont déja 10 new affinity-scores_today
          next if mate.new_affinity_scores_today.count >= max_count
          # Calculer coordonées du jour du user sauf si elles ont déja été calculées aujourd'hui
          GEOCODE.coordinates(user) unless user.coordinates_updated_today == true
          # Si le mate est dans le périmetre, calculer le match percentage
          AFFINITIES.match_percentage(user, mate) if PREFERENCE.mate_in_perimeter?(user, mate)
        end
        i += 1
      end
    end
  end

  private

  def initialize_update(users)
    # Initialiser les paramètres
    users.each do |user|
      user.new_affinity_scores_today = 0
      user.coordinates_updated_today = false
      user.save!
=======

  def perform
    # TODO : implémenter la réccurence une fois par jour, mais d'abord pouvoir le faire sur commande.
    # users = User.all
    users = User.all
    users.each do |user|
      mates = User.all.shuffle.each_slice(2).to_a
      i = 0
      user.new_affinity_scores_today = 0

      until user.new_affinity_scores_today == 2 || mates[i].nil?
        # Commencer par calculer local lat et local lon du user pour pas avoir a le refaire a chaque fois
        GEOCODE.coordinates(user)
        # selectionner ceux du bon age et sexe
        p mates[i], "this is mates[#{i}], there are this nmber of mates:#{mates[i].count}"
        if !mates[i].nil?
          mates_with_right_gender_and_age = Preferences.array_of_gender_and_age_preferences(user, mates[i])
          p "mates_with_right_gender_and_age : #{mates_with_right_gender_and_age}"

          # Rejeter ceux avec un score de match préexistant avec moi
          mates_without_score = Preferences.reject_mates_with_affinity_score_with_user(user, mates_with_right_gender_and_age)
          p "mates without score : #{mates_without_score.count}"

          # Rejeter les mates qui ont déja un match avec moi
          mates_without_match_with_me = Preferences.reject_matches(user, mates_without_score)
          p "mates_without_match_with_me : #{mates_without_match_with_me.count}"

          # Rejeter les mates qui ont déja 10 new affinity-scores_today
          potential_mates = Preferences.reject_mates_with_too_much_new_affinity_scores_today(mates_without_match_with_me)
          p "potential_mates: #{potential_mates.count}"

          # Calculer ceux dans le périmètre
          mates_in_perimeter = Preferences.mates_in_perimeter(user, potential_mates)
          p "mates_in_perimeter : #{mates_in_perimeter.count}"

          # A moins que mates_in_perimeter soit vide, calculer le score de match avec ces mates et incrémenter new affinity_scores_today a chaque fois
          AFFINITIES.match_percentage(user, mates_in_perimeter) unless mates_in_perimeter.empty?
          if !mates[i+1].nil?
            i += 1
          else
            break
          end
        end
      end
>>>>>>> 3a55946a230a6eef5b91bb10f0d08124f86a1e94
    end
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
