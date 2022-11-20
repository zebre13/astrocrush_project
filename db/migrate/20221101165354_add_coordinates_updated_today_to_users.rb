class AddCoordinatesUpdatedTodayToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :coordinates_updated_today, :boolean, default: false
  end
end
