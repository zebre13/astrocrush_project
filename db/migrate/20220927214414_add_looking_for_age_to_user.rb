class AddLookingForAgeToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :minimal_age, :integer
    add_column :users, :maximum_age, :integer
  end
end
