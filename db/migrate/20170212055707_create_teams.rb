class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :team_name
      t.string :slack_channel
      t.string :batch
      t.text :description
      t.string :app_website
      t.string :github_repo

      t.timestamps
    end
    add_index :teams, :team_name, unique: true
    add_index :teams, :batch
  end
end
