class RemovePlanetFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :planets, :string
  end
end
