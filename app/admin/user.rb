ActiveAdmin.register User do
  permit_params :name, :surname, :email, :phone, :role, :active, :notification,
                :newsletter, :celebret_url, :password, :password_confirmation,
                :os, :push_token

  index do
    selectable_column
    id_column
    column :email
    column :created_at
    actions
  end

  filter :email

  form do |f|
    f.inputs 'User Details' do
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end
end
