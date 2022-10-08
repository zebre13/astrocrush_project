class AddNumberOfNewAffinityScoresOfTodayToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :new_affinity_scores_today, :integer, default: 0
  end
end
