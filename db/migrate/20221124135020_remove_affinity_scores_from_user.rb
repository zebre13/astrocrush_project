class RemoveAffinityScoresFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :affinity_scores, :text
    remove_column :users, :partner_reports, :text
  end
end
