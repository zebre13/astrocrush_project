class AddLoveCompatibilityReportToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :love_compatibility_report, :text
  end
end
