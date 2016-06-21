ActiveAdmin.register SubCategory do
  permit_params :category_id, :name

  index do
    selectable_column
    id_column
    column :category
    column :name
    actions
  end

  filter :category
  filter :name

  form do |f|
    f.inputs 'SubCategory Details' do
      f.semantic_errors(*f.object.errors.keys)
      f.input :category
      f.input :name
    end
    f.actions
  end
end
