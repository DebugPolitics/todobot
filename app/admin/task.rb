ActiveAdmin.register Task do
  filter :has_expired
  filter :is_multi_use
  permit_params :description, :is_multi_use, :has_expired, :bounty
  actions :all, except: [:destroy]
end
