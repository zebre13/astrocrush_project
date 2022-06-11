class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :birth_country, :string
  end
end
