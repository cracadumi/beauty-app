ActiveAdmin.register PaymentMethod do
  permit_params :user_id, :payment_type, :last_4_digits, :card_type, :default

  index do
    selectable_column
    id_column
    column :user
    column :payment_type
    column :last_4_digits
    column :default
    actions
  end

  filter :user
  filter :payment_type
  filter :last_4_digits

  form do |f|
    f.inputs 'PaymentMethod Details' do
      f.input :user
      f.input :payment_type
      f.input :last_4_digits
      f.input :card_type
      f.input :default
    end
    f.actions
  end
end
