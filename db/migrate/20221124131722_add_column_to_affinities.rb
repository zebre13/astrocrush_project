class AddColumnToAffinities < ActiveRecord::Migration[6.1]
  def change
    add_column :affinities, :mate_id, :integer
  end
end
