class Team < ApplicationRecord
  has_many :users, through: :team_members
end
