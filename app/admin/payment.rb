ActiveAdmin.register Payment do
  permit_params :booking_id, :user_id, :payment_method_id, :paid_at, :amount

  index do
    selectable_column
    id_column
    column :booking
    column :user
    column :payment_method
    column :paid_at
    column :amount
    actions
  end

  filter :booking
  filter :user
  filter :payment_method
  filter :paid_at
  filter :amount

  form do |f|
    f.inputs 'Payment Details' do
      f.input :booking
      f.input :user
      f.input :payment_method
      f.input :paid_at
      f.input :amount
    end
    f.actions
  end
end
