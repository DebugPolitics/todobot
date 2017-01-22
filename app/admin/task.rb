ActiveAdmin.register Task do
  filter :has_expired
  filter :is_multi_use
  filter :categories

  permit_params :description, :is_multi_use, :has_expired, :bounty, category_ids: [:name]

  actions :all, except: [:destroy]

  # form do |f|
  #   f.semantic_errors
  #   f.input :description
  #   f.input :categories, :as => :check_boxes, :collection => Category.all
  #   f.input :is_multi_use
  #   f.input :has_expired
  #   f.input :bounty
  #   f.actions
  # end
end
