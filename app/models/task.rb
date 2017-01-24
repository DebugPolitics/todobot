class Task < ApplicationRecord
  has_and_belongs_to_many :users,  join_table: :task_completions
  has_and_belongs_to_many :categories

  validates :description, presence: true

  def self.unexpired
    where(has_expired: false)
  end

end
