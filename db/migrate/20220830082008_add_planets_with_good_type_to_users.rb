class AddPlanetsWithGoodTypeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :planets, :text
  end
end
