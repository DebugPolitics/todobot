class CreateTask < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.text :description,      null: false
      t.boolean :is_multi_use,  null: false, default: false

      t.timestamps
    end
  end
end
