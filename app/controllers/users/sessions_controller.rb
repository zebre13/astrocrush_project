# frozen_string_literal: true
require_relative '../../../app/services/astrology_api.rb'

class Users::SessionsController < Devise::SessionsController
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])
  before_action :define_coordinates, only: %i[new create]

  # TODO En boucle tous les jours à minuit (et tant que l'utilisateur existe? / S'est connecté dans la derniere semeaine?), do (while Time.now == 00:00:00 do )
    # récupérer les current_lat et current_lon du current_user en fonction de l'adresse ip de sa derniere connexion
      # ajouter les colonnes current_lon et current_lat à la colonne User (rails g migration AddCurrentLatAndCurrentLontoUser)
      # Trouver un moyen d'obtenir le l'adresse IP de l'utilisateur ( avec devise)
      # déclencher API Geocoding pour obtenir les coordonnées
      current_user.current_lat = #resultat de l'api
      current_user.current_lon = #resultat de l'api

    # mettre à jour les préférences utilisateurs concernant le current_user.search_perimeter
      # rassembler les utilisateurs dont la distance entre leur coordonnées est inférieure ou égale à current_user.rayon
    # parmis eux exclure les utilisateurs avec un affinity_score déjà présent
    # Puis exclure ceux avec qui j'ai déja matché ou j'ai déja disliké ( comme dans l'index controlleur de base)

    # calculer 10 nouveaux scores à partir des users obtenus
      # mettre à jour l'index.

  private

  def define_coordinates
    ip = request.remote_ip
    current_user.local_lat = Geocoder.search(request.remote_ip).first.coordinates[0]
    current_user.local_lon = Geocoder.search(ip).first.coordinates[1]
  end

  # def calcul_ten_scores
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
