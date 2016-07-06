json.extract! favorite, :id

json.beautician do
  json.extract! favorite.beautician, :id, :name, :surname
  json.profile_picture do
    json.s70 favorite.beautician.profile_picture.url(:s70)
  end if favorite.beautician.profile_picture?
  json.categories favorite.beautician.categories.map(&:name).join(', ')
end
