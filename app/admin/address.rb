ActiveAdmin.register Address do
  permit_params :addressable_id, :addressable_type, :street, :postcode, :city,
                :state, :country, :latitude, :longitude

  index do
    selectable_column
    id_column
    column :addressable
    column(:address) { |a| a.display_name || '–' }
    column(:coordinates) { |a| a.coordinates || '–' }
    actions
  end

  filter :addressable, as: :select, collection: Address.all.map(&:addressable)

  form do |f|
    f.inputs 'Address Details' do
      f.input :street
      f.input :postcode
      f.input :city
      f.input :state
      f.input :country, priority_countries: %w(FR GB DE)
      f.input :latitude
      f.input :longitude
    end
    f.actions
  end
end
