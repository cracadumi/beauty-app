ActiveAdmin.register Language do
  permit_params :name, :country, :flag_url

  index do
    selectable_column
    id_column
    column :name
    column :country
    column(:flag) do |a|
      image_tag(a.flag_url, height: 50) if a.flag_url.present?
    end
    actions
  end

  filter :name

  form do |f|
    f.inputs 'Language Details' do
      f.input :name
      f.input :country, priority_countries: %w(FR GB DE)
      f.input :flag_url
    end
    f.actions
  end
end
