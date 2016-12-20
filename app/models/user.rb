class User < ApplicationRecord
  has_and_belongs_to_many :tasks, join_table: :task_completions

  validates :name, presence: true
  validates :slack_id, presence: true, uniqueness: true
end