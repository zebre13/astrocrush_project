class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.string :title
      t.text :msg
      t.string :tags
      t.references :affinity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
