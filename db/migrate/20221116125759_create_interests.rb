class CreateInterests < ActiveRecord::Migration[6.1]
  def change
    create_table :interests do |t|
      t.string :name
      t.string :emoji

      t.timestamps
    end
  end
end
