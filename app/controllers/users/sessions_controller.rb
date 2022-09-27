# frozen_string_literal: true
require_relative '../../../app/services/astrology_api.rb'

class Users::SessionsController < Devise::SessionsController
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])
  # after_action :define_coordinates, only: %i[new create] (Faut trouver le timing mais on peut pas le faire à chaque session, il faut que ca soit fait quotidiennement sinon l'user se déco reco sans cesse pour rafraichir ses mates)

  # TODO En boucle tous les jours à minuit (et tant que l'utilisateur existe? / S'est connecté dans la derniere semeaine?), do (while Time.now == 00:00:00 do )
  while (Time.now.hour == 00 && Time.now.minutes == 0 && Time.now.sec == 1)do
    # récupérer les coordonnées du current user
    define_coordinates
    
    # utiliser current_user.search_perimeter ( a créer et migrer et mettre dans le signup et edit)
    users_by_preference = User.where(gender: current_user.looking_for).where.not(id: current_user.id)

    # rassembler les utilisateurs dont la distance entre leur coordonnées est inférieure ou égale à current_user.rayon
    users_in_perimeter = []
    users_by_preference.each do |mate|
      # calculer les distances avec chacun de ces utilisateur
      distance = calculate_distance(current_user, mate)
      if distance <= current_user.search_perimeter
        users_in_perimeter << user
      end
    end

      # parmis eux exclure les utilisateurs avec un affinity_score déjà présent
      users_in_perimeter.reject {|user| user.affinity_scores.include?(current_user.id)}
      # Puis exclure ceux avec qui j'ai déja matché ou j'ai déja disliké ( comme dans l'index controlleur de base)

      # calculer 10 nouveaux scores à partir des users obtenus
        # mettre à jour l'index.
  end
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
