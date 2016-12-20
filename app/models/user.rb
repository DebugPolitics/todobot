class User < ApplicationRecord
  has_and_belongs_to_many :tasks, join_table: :task_completions

  validates :name, presence: true
  validates :slack_id, presence: true, uniqueness: true

  def get_random_task
    already_completed_task_ids = self.tasks.where(is_multi_use: false).pluck(:id)
    candidate_tasks = Task.where(has_expired: false)
                          .where.not(id: already_completed_task_ids)
    candidate_tasks.sample
  end
end