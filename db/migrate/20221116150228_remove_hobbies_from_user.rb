class RemoveHobbiesFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :hobbies, :string
  end
end