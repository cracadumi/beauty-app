ActiveAdmin.register Review do
  permit_params :booking_id, :rating, :comment, :author_id, :visible

  index do
    selectable_column
    id_column
    column :booking
    column :user
    column :author
    column :rating
    column :visible
    actions
  end

  filter :booking
  filter :user
  filter :author
  filter :visible

  form do |f|
    f.inputs 'Review Details' do
      f.semantic_errors(*f.object.errors.keys)
      f.input :booking
      f.input :rating
      f.input :comment
      f.input :author
      f.input :visible
    end
    f.actions
  end
end
