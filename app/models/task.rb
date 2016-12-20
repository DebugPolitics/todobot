class Task < ApplicationRecord
  has_and_belongs_to_many :users,  join_table: :task_completions

  validates :description, presence: true
end