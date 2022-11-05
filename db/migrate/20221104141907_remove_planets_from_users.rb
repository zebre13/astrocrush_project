class RemovePlanetsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :planets, :text
  end
end
