class AddPersonalityToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :personality_report, :text
  end
end
