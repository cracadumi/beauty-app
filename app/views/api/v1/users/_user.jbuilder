json.extract! user, :id, :name, :surname, :username, :role, :email, :sex, :bio,
              :phone_number, :dob_on, :profile_picture_url, :active,
              :rating
if user.active?
  json.latitude user.latitude
  json.longitude user.longitude
end
