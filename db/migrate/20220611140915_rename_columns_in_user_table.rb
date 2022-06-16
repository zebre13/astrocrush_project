class RenameColumnsInUserTable < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :star_sign, :sign
  end
end
