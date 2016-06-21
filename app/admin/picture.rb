ActiveAdmin.register Picture do
  permit_params :picturable_id, :picturable_type, :title, :description,
                :picture_url

  index do
    selectable_column
    id_column
    column :picturable
    column(:picture) do |a|
      image_tag a.picture_url, height: 30 if a.picture_url
    end
    column :title
    actions
  end

  filter :picturable, as: :select, collection: Picture.all.map(&:picturable)

  form do |f|
    f.inputs 'Picture Details' do
      f.semantic_errors(*f.object.errors.keys)
      f.input :picturable_id
      f.input :picturable_type
      f.input :title
      f.input :description
      f.input :picture_url
    end
    f.actions
  end
end
