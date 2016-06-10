ActiveAdmin.register SettingsBeautician do
  permit_params :user_id, :instant_booking, :advance_booking, :mobile, :office,
                :profession

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
      f.input :user, as: :select, collection: User.all.collection_for_admin
      f.input :profession
      f.input :instant_booking
      f.input :advance_booking
      f.input :mobile
      f.input :office
    end
    f.actions
  end
end
