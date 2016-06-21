ActiveAdmin.register SettingsBeautician do
  permit_params :user_id, :instant_booking, :advance_booking, :mobile, :office,
                :profession,
                office_address_attributes: [:street, :postcode, :city, :state,
                                            :country, :latitude, :longitude]

  index do
    selectable_column
    id_column
    column :user
    column :profession
    column :instant_booking
    column :advance_booking
    column :mobile
    column :office
    actions
  end

  filter :user
  filter :profession
  filter :instant_booking
  filter :advance_booking
  filter :mobile
  filter :office

  form do |f|
    f.inputs 'SettingsBeautician Details' do
      f.semantic_errors(*f.object.errors.keys)
      f.input :user, as: :select, collection: User.all.collection_for_admin
      f.input :profession
      f.input :instant_booking
      f.input :advance_booking
      f.input :mobile
      f.input :office
      f.inputs 'Office address' do
        f.semantic_fields_for :office_address, (f.object.office_address ||
            f.object.build_office_address) do |meta_form|
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
