class CreateAffinities < ActiveRecord::Migration[6.1]
  def change
    create_table :affinities do |t|
      t.integer :score
      t.text :report
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
