class AddScoresToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :affinity_scores, :string
  end
end
