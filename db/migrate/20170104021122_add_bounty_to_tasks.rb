class AddBountyToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :bounty, :integer
  end
end
