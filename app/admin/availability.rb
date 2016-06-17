ActiveAdmin.register Availability do
  permit_params :settings_beautician_id, :day, :starts_at, :ends_at,
                :working_day

  index do
    selectable_column
    id_column
    column(:user) { |e| e.settings_beautician.user.display_name }
    column :settings_beautician
    column :day
    column(:time) do |e|
      "#{e.starts_at.strftime('%H:%M')}–#{e.ends_at.strftime('%H:%M')}"
    end
    column :working_day
    actions
  end

  filter :settings_beautician
  filter :day
  filter :working_day
  filter :advance_boo

  form do |f|
    f.inputs 'Availability Details' do
      f.input :settings_beautician,
              as: :select,
              collection: SettingsBeautician.all.collection_for_admin
      f.input :day
      f.input :starts_at
      f.input :ends_at
      f.input :working_day
    end
    f.actions
  end
end
