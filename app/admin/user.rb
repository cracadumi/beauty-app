ActiveAdmin.register User do
  permit_params :email, :name, :surname, :username, :role, :sex, :bio,
                :phone_number, :dob_on, :profile_picture, :active, :archived,
                :latitude, :longitude, :rating, :facebook_id, :password,
                :password_confirmation, :language_id,
                address_attributes: [:street, :postcode, :city, :state,
                                     :country, :latitude, :longitude]

  index do
    selectable_column
    id_column
    column :full_name
    column :email
    column :role
    actions
  end

  filter :name
  filter :surname
  filter :username
  filter :email
  filter :phone_number
  filter :active
  filter :archived

  form do |f|
    f.inputs 'User Details' do
      f.semantic_errors(*f.object.errors.keys)
      f.input :email
      f.input :name
      f.input :surname
      f.input :username
      f.input :role, as: :select, collection: User.roles.keys
      f.input :sex, as: :select, collection: User.sexes.keys
      f.input :bio
      f.input :phone_number
      f.input :dob_on
      f.input :profile_picture, as: :file
      f.input :active
      f.input :archived
      f.input :latitude
      f.input :longitude
      f.input :rating
      f.input :facebook_id
      f.input :language
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
      f.inputs 'Address' do
        f.semantic_fields_for :address, (f.object.address ||
            f.object.build_address) do |meta_form|
          meta_form.semantic_errors(*f.object.errors.keys)
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
