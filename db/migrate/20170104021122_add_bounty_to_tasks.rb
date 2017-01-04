class AddBountyToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :bounty, :integer, default: 1
    Task.reset_column_information
    Task.update_all bounty: 1
  end
end
