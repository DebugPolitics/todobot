class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    create_join_table :categories, :tasks

    create_join_table :categories, :users

    add_index :categories, :name, unique: false
  end
end
