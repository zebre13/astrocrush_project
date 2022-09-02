class AddAffinityScoresToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :affinity_scores, :text
  end
end
