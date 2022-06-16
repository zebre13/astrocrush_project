class AddRomanticPersonalityReportToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :romantic_personality_report, :text
  end
end
