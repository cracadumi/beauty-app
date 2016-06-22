ActiveAdmin.register Booking do
  permit_params :status, :user_id, :beautician_id, :datetime_at,
                :notes, :unavailability_explanation, :checked_in, :instant,
                :reschedule_at,
                service_ids: [],
                address_attributes: [:street, :postcode, :city, :state,
                                     :country, :latitude, :longitude]

  member_action :set_status, method: :put do
    state = params[:state]
    resource.send("#{state}!")
    redirect_to resource_path, notice: 'Status changed!'
  end

  index do
    selectable_column
    id_column
    column :user
    column :beautician
    column :items
    column(:total_price) { |e| number_to_currency(e.total_price) }
    column :status
    column(:change_status) do |e|
      links = []
      links << link_to('Accept',
                       set_status_admin_booking_path(e, state: :accept),
                       method: :put) if e.may_accept?
      links << link_to('Expire',
                       set_status_admin_booking_path(e, state: :expire),
                       method: :put) if e.may_expire?
      links << link_to('Refuse',
                       set_status_admin_booking_path(e, state: :refuse),
                       method: :put) if e.may_refuse?
      links << link_to('Complete',
                       set_status_admin_booking_path(e, state: :complete),
                       method: :put) if e.may_complete?
      links << link_to('Cancel',
                       set_status_admin_booking_path(e, state: :cancel),
                       method: :put) if e.may_cancel?
      links << link_to('Reschedule',
                       set_status_admin_booking_path(e, state: :reschedule),
                       method: :put) if e.may_reschedule?
      raw links.join('<br>')
    end
    actions
  end

  filter :user
  filter :beautician
  filter :status

  form do |f|
    f.inputs 'Booking Details' do
      f.semantic_errors(*f.object.errors.keys)
      f.input :status, label: 'Status, for tests only!',
                       hint: 'Doesn\'t fire callbacks. Use links on bookings
                              list page to change status.'
      f.input :user_id, as: :select, collection: User.users.collection_for_admin
      f.input :beautician_id, as: :select,
                              collection: User.beauticians.collection_for_admin
      f.input :datetime_at
      f.input :notes
      f.input :unavailability_explanation
      f.input :checked_in
      f.input :instant
      f.input :reschedule_at
      f.input :services
      f.inputs 'Address' do
        f.semantic_fields_for :address, (f.object.address ||
            f.object.build_address) do |meta_form|
          meta_form.semantic_errors(*meta_form.object.errors.keys)
          meta_form.input :street
          meta_form.input :postcode
          meta_form.input :city
          meta_form.input :state
          meta_form.input :country, priority_countries: %w(FR GB DE)
          meta_form.input :latitude
          meta_form.input :longitude
        end
      end
    end
    f.actions
  end
end
