ActiveAdmin.register Service do
  permit_params :user_id, :sub_category_id, :price

  index do
    selectable_column
    id_column
    column :user
    column :sub_category
    column(:price) { |e| number_to_currency(e.price) }
    actions
  end

  filter :user
  filter :sub_category

  form do |f|
    f.inputs 'Service Details' do
      f.semantic_errors(*f.object.errors.keys)
      f.input :user
      f.input :sub_category
      f.input :price
    end
    f.actions
  end
end
