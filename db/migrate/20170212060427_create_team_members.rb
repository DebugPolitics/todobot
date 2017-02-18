class CreateTeamMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :team_members, :id => false do |t|
      t.belongs_to :team
      t.belongs_to :user
      t.boolean :point_of_contact, default: false

      t.timestamps
    end
  end
end
