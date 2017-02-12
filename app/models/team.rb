class Team < ApplicationRecord
  has_many :users, through: :team_members
  has_many :team_members
end
