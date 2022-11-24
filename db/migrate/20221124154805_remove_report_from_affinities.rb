class RemoveReportFromAffinities < ActiveRecord::Migration[6.1]
  def change
    remove_column :affinities, :report, :text
  end
end
