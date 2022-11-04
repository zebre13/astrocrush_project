class RemovePersonalityReportFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :personality_report, :text
  end
end
