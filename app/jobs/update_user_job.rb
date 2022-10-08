class UpdateUserJob < ApplicationJob
  queue_as :default

  def perform(users)
    # TODO : une fois par jour

    # Set le nombre de nouveaux affinity scores quotidien à 0.
    user.each{ |user| user.new_affinity_scores_today = 0 }

    # Calculer des nouveaux scores pour tout le monde
    users.each do |user|
      # Calculer le nombre d'affinity scores à calculer pour l'user en question
      number_of_scores_to_calculate = 10 - user.new_affinity_scores_today
      update_index(user, number_of_scores_to_calculate)
    end
  end

  def update_index(user, number_of_scores_to_calculate)

    # Définir les coordonnées de l'user qu'on update
    define_coordinates(user)

    # Mates du bon age et genre
    potential_mates = PREFERENCES.array_of_gender_and_age_preferences(user)

    # Filtre de ceux dans le périmetre
    mates_in_perimeter = PREFERENCES.mates_in_perimeter(user, potential_mates)

    # Selectionner pour ensuite rejeter les utilisateurs qui ont un score de match calculé avec moi
    mates_without_score = PREFERENCES.reject_mates_with_affinity_score_with_user(user, mates_in_perimeter)

    # On rejette tous les users qui sont dans les matchs du current user et on en prend 10
    n_mates = PREFERENCES.reject_matches(user, mates_without_score).sample(number_of_scores_to_calculate)

    # Calculer l'affinity scores avec ces ten_users
    AFFINITIES.match_percentage(user, n_mates)

    # Màj le nombre de nouveaux affinity_scores de chacun des n_mates
    n_mates.each{ |mate| mate.new_affinity_scores_today += 1 }

  end
    # Si un user B voit son index updaté comprenant un score avec user A, alors en calculer un de moins
    # En fait chaque jour, si le nombre de nouveaux scores que users A obtient via l'update d'index d'autres users est < 10
    # Déclencher l'update de l'index afin que ce nombre de nouveaux score de A passe à 10.
    # Pour récupérer les novueaux scores de match obtenus afin de faire ce calcul, il faut récupérer les matchs avec A qui ont été create à date de Date.today
    # Ex si today a minuit les users B, C et D on des nouveaux scores avec A grace à leur propre update,
    # alors compter ces nouveaux scores de match impliquant A qui ont été crée a Date.today
    # et les soustraire du nombre de users qu'on va aller cherche pour update A.

  end
end
