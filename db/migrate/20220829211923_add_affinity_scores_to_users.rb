class AddAffinityScoresToUsers < ActiveRecord::Migration[6.1]
  def change
    enable_extension "hstore"
    add_column :users, :affinity_scores, :hstore
    add_index :users, :affinity_scores, using: :gin
  end
end
