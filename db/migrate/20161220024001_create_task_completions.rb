class CreateTaskCompletions < ActiveRecord::Migration[5.0]
  def change
    create_table :task_completions do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.belongs_to :task, null: false, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
