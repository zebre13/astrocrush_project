class AddChartToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :wheel_chart, :string
  end
end
