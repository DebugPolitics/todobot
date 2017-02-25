ActiveAdmin.register Team do
  permit_params :name, :slack_channel, :batch, :description, :app_website, :github_repo, user_ids: []
end
