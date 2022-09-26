class AddCoordinatesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :local_lat, :float
    add_column :users, :local_lon, :float
  end
end
