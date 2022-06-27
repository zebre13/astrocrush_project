class RenameColumninUsersTable < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :planet_reports, :mate_sun_reports
  end
end
