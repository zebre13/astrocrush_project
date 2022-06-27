class RenameColumnsInUsersTable < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :romantic_personality_report, :partner_reports
    rename_column :users, :love_compatibility_reports, :planet_reports
  end
end
