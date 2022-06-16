class FixColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :love_compatibility_report, :love_compatibility_reports
  end
end
