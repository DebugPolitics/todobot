ActiveAdmin.register User do
  filter :categories
  filter :teams, member_label: :team_name

  permit_params :name, :slack_id, :email, :github, category_ids: [], team_ids: []

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :slack_id
      f.input :email, as: :email
      f.input :github, as: :url
      f.input :categories, as: :check_boxes, checked: Category.pluck(&:id)
      if Team.count > 0
        f.input :teams, member_label: :team_name
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :slack_id
      row :email
      row :github
      table_for user.categories do |cat|
        column('Categories', :name)
      end
      row :teams do |t|
        t.teams.map { |team| team.team_name }.join(', ')
      end
    end
  end

  index do
    id_column
    column :name
    column :slack_id
    column :email
    column :categories do |t|
      t.categories.map { |c| c.name }.join(', ')
    end
    column :teams do |t|
      t.teams.map { |team| team.team_name }.join(', ')
    end
    actions
  end
end
