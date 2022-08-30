class AddPartnerReportsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :partner_reports, :text
  end
end
