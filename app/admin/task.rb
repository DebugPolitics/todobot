ActiveAdmin.register Task do
  filter :has_expired
  filter :is_multi_use
  filter :categories

  permit_params :description, :is_multi_use, :has_expired, :bounty, category_ids: []

  actions :all, except: [:destroy]

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :description
      f.input :is_multi_use
      f.input :has_expired
      f.input :bounty
      f.input :categories, as: :check_boxes, checked: Category.pluck(&:id)
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :description
      row :is_multi_use
      row :has_expired
      row :bounty
      table_for task.categories do |cat|
        column('Categories', :name)
      end
    end
  end

  index do
    id_column
    column :description
    column :is_multi_use
    column :has_expired
    column :bounty
    column :categories do |t|
      t.categories.map do |c|
        c.name
      end.join(', ')
    end
    actions
  end
end
