ActiveAdmin.register Refund do
  permit_params :booking_id, :refunded_at, :amount_refunded_to_performer,
                :amount_refunded_to_customer

  index do
    selectable_column
    id_column
    column :booking
    column :refunded_at
    column :amount_refunded_to_performer
    column :amount_refunded_to_customer
    actions
  end

  filter :booking

  form do |f|
    f.inputs 'Refund Details' do
      f.input :booking
      f.input :refunded_at
      f.input :amount_refunded_to_performer
      f.input :amount_refunded_to_customer
    end
    f.actions
  end
end
