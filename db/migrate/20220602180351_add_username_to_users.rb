class AddUsernameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string
    add_column :users, :description, :text
    add_column :users, :hobbies, :string
    add_column :users, :birth_date, :date
    add_column :users, :birth_hour, :time
    add_column :users, :birth_location, :string
    add_column :users, :gender, :integer
    add_column :users, :looking_for, :integer
    add_column :users, :star_sign, :string
    add_column :users, :rising, :string
    add_column :users, :moon, :string
  end
end
