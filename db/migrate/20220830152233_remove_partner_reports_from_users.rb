class RemovePartnerReportsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :partner_reports, :text
  end
end
