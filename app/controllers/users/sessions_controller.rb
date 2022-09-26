# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # à chaque connection lancer la fonction
  after_action :calcul_ten_scores, only: [:new]

  def calcul_ten_scores
  # récupérer les local_lat et local_lon du current_user en fonction de l'adresse ip
  # mettre à jour les préférences utilisateurs
  # virer les users avec un affinity_score déjà présent
  # calculer 10 nouveaux scores à partir des users obtenus
  end





  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
