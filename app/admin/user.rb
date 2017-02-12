ActiveAdmin.register User do
  permit_params :name, :slack_id, :email, :github, team_ids: []
end
