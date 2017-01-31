class User < ApplicationRecord
  has_and_belongs_to_many :tasks, join_table: :task_completions
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :slack_id, presence: true, uniqueness: true

  def get_random_task(exclude: nil)
    excluded_task_ids = completed_tasks.pluck(:id)
    excluded_task_ids << exclude.id if exclude.present?
    # Skill selection:
    # If the user has no skills listed, fallback to the old filter.
    # Otherwise, prefer tasks that are a match to the user's skill set
    # then fall back to tasks with no skills listed.
    user_skills = self.categories
    candidate_tasks = []
    if user_skills.length == 0
      get_random_task_no_categories(exclude: exclude)
    else
      # tasks that have categories
      category_task_ids = Task.joins(:categories).distinct.pluck(:id)
      # tasks that match the user's categories
      candidate_tasks = Task.unexpired
                           .where.not(id: excluded_task_ids)
                           .left_outer_joins(:categories)
                             .where(categories: { id: user_skills })
      # tasks that don't have any categories
      tasks_without_categories = Task.unexpired
                           .where.not(id: excluded_task_ids)
                           .where.not(id: category_task_ids)
      # prefer tasks that match, then fallback to tasks without categories
      candidate_tasks.sample || tasks_without_categories.sample
    end

  end

  def get_random_task_no_categories(exclude: nil)
    excluded_task_ids = completed_tasks.pluck(:id)
    excluded_task_ids << exclude.id if exclude.present?
    candidate_tasks = Task.unexpired
                          .where.not(id: excluded_task_ids)
    candidate_tasks.sample
  end

  def completed_tasks
    self.tasks.where(is_multi_use: false)
  end

  def skill_list
    self.categories.map { |c| c.name }.join(', ')
  end
end
