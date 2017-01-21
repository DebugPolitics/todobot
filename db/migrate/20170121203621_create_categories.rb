class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    create_join_table :task, :categories

    create_join_table :user, :categories
  end
end
