class AddMateSunReportsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :mate_sun_reports, :text
  end
end
