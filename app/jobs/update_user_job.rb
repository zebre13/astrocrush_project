class UpdateUserJob < ApplicationJob
  queue_as :default

  def perform(users)
    users.each do |user|
      update_index(user)
    end
  end

  def update_index
    helpers.define_coordinates
    # current_user.local_lat = Geocoder.search(request.remote_ip).first.coordinates[0]
    # current_user.local_lon = Geocoder.search(request.remote_ip).first.coordinates[1]
    
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
