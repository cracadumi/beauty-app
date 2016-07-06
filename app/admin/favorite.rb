ActiveAdmin.register Favorite do
  permit_params :beautician_id, :user_id

  index do
    selectable_column
    id_column
    column :user
    column :beautician
    actions
  end

  filter :user
  filter :beautician

  form do |f|
    f.inputs 'Favorite Details' do
      f.semantic_errors(*f.object.errors.keys)
      f.input :beautician, as: :select,
                           collection: User.beauticians.collection_for_admin
      f.input :user, as: :select,
                     collection: User.users.collection_for_admin
    end
    f.actions
  end
end
