class User < ApplicationRecord
  has_and_belongs_to_many :tasks, join_table: :task_completions
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :slack_id, presence: true, uniqueness: true

  def get_random_task(exclude: nil)
    excluded_task_ids = completed_tasks.pluck(:id)
    excluded_task_ids << exclude.id if exclude.present?
    # Skill selection:
    # If the user has no skills listed, don't filter by skill
    # Otherwise, sort by the length of (User.skills & Task.skills)
    # using a left outer join to include tasks with no skills listed.
    user_skills = self.categories
    if user_skills.length == 0
      candidate_tasks = Task.where(has_expired: false)
                            .where.not(id: excluded_task_ids)
    else
      candidate_tasks = Task.where(has_expired: false)
                           .where.not(id: excluded_task_ids)
                           .left_outer_joins(:categories)
                             .where(categories: { id: user_skills })
      print candidate_tasks.explain
    end
    candidate_tasks.sample
  end

  def completed_tasks
    self.tasks.where(is_multi_use: false)
  end
end
