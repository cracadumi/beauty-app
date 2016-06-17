ActiveAdmin.register Booking do
  permit_params :status, :user_id, :beautician_id, :datetime_at, :pay_to_beautician,
                :total_price, :notes, :unavailability_explanation, :checked_in,
                :expires_at, :instant, :reschedule_at, :items, service_ids: []

  index do
    selectable_column
    id_column
    column :user
    column :beautician
    column :items
    column :status
    actions
  end

  filter :user
  filter :beautician
  filter :status

  form do |f|
    f.inputs 'Booking Details' do
      f.input :status
      f.input :user_id, as: :select, collection: User.users.collection_for_admin
      f.input :beautician_id, as: :select,
              collection: User.beauticians.collection_for_admin
      f.input :datetime_at
      f.input :pay_to_beautician
      f.input :total_price
      f.input :notes
      f.input :unavailability_explanation
      f.input :checked_in
      f.input :expires_at
      f.input :instant
      f.input :reschedule_at
      f.input :services
    end
    f.actions
  end
end
