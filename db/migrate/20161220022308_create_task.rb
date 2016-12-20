class CreateTask < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.text :description,      null: false
      t.boolean :is_multi_use,  null: false, default: false, index: true
      t.boolean :has_expired,   null: false, default: true,  index: true

      t.timestamps
    end
  end
end
