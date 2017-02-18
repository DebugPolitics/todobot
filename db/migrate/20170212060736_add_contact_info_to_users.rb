class AddContactInfoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email, :string
    add_column :users, :github, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    rename_column :users, :name, :slack_name
  end
end
