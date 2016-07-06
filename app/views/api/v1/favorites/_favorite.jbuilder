json.extract! favorite, :id

json.beautician do
  json.extract! favorite.beautician, :id, :name, :surname, :profile_picture_url
  json.categories favorite.beautician.categories.map(&:name).join(', ')
end
