class Category < ApplicationRecord
  has_and_belongs_to_many :tasks
  has_and_belongs_to_many :users

  @@categoryList = nil

  def self.categoryList
    if @@categoryList == nil
      @@categoryList = Category.all.map { |c| "#{c.id} - #{c.name}"}.join(", ")
    end
    @@categoryList
  end

  # force a lazy recalculate after any change
  after_save do
    @@categoryList = nil
  end
end
