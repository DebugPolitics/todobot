class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name,   null: false
      t.string :slack_id, null: false

      t.timestamps
    end

    add_index :users, :slack_id, unique: true
  end
end
