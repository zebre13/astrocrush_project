class AddLookingForAgeToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :minimal_age, :integer, default: 8
    add_column :users, :maximum_age, :integer, default: 88
  end
end
