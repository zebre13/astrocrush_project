class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :country, :string
    add_column :users, :city, :string
  end
end
