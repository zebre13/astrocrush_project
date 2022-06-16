class AddPlanetsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :planets, :string
  end
end
