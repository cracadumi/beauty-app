ActiveAdmin.register_page 'Settings' do
  title = 'Settings'
  menu label: title
  active_admin_settings_page(title: title) unless Rails.env.development?
end
