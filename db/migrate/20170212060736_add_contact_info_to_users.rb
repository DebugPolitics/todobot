class AddContactInfoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email, :string
    add_column :users, :github, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    rename_column :users, :name, :slack_name

    add_index :users, [:first_name, :last_name]

    reversible do |dir|
      User.reset_column_information
      # Since users can be created other than via slack, we need to make it a nullable
      dir.up { change_column_null :users, :slack_name, true }
      dir.down do
        User.where(slack_name: nil) { |u| u.destroy }
        change_column_null :users, :slack_name, false
      end
    end
  end

end
