ActiveAdmin.register User do
  filter :categories
  filter :teams
  filter :team_members, member_label: :point_of_contact

  permit_params :name, :slack_id, :email, :github, category_ids: [], team_ids: []

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :slack_name
      f.input :slack_id
      f.input :email, as: :email
      f.input :github, as: :url
      f.input :categories, as: :check_boxes, checked: Category.pluck(&:id)
      if Team.count > 0
        f.inputs do
          f.has_many :teams, new_record: false, allow_destroy: false do |team|
            team.input
          end
        end
      end
    end
    f.actions
  end

  sidebar :teams do
    if resource
      resource.teams do |team|
        team.name
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :slack_name
      row :slack_id
      row :email
      row :github
      table_for user.categories do |cat|
        column('Categories', :name)
      end
      row :teams do |t|
        t.teams.map { |team| team.name }.join(', ')
      end
    end
  end

  index do
    id_column
    column :first_name
    column :last_name
    column :slack_name
    column :slack_id
    column :email
    column :categories do |t|
      t.categories.map { |c| c.name }.join(', ')
    end
    column :teams do |t|
      t.teams.map { |team| team.name }.join(', ')
    end
    actions
  end
end
