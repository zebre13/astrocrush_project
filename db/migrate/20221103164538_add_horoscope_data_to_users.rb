class AddHoroscopeDataToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :horoscope_data, :text
  end
end
