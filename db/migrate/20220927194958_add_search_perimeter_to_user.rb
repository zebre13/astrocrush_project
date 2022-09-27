class AddSearchPerimeterToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :search_perimeter, :integer
  end
end
