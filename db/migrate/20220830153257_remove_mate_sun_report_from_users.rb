class RemoveMateSunReportFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :mate_sun_reports, :text
  end
end
