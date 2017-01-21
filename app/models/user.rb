class User < ApplicationRecord
  has_and_belongs_to_many :tasks, join_table: :task_completions
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :slack_id, presence: true, uniqueness: true

  def get_random_task(exclude: nil)
    excluded_task_ids = completed_tasks.pluck(:id)
    excluded_task_ids << exclude.id if exclude.present?
    candidate_tasks = Task.where(has_expired: false)
                          .where.not(id: excluded_task_ids)
                          .where((categories & self.categories).length > 0)
    candidate_tasks.sample
  end

  def completed_tasks
    self.tasks.where(is_multi_use: false)
  end
end
