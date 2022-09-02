class RemoveAffinityScoresFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :affinity_scores, :string
  end
end
