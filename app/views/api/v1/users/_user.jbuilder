json.extract! user, :id, :name, :surname, :username, :role, :email, :sex, :bio,
              :phone_number, :dob_on, :profile_picture_url, :active,
              :rating, :created_at

if user.beautician?
  if user.recently_tracked?
    json.extract! user, :latitude, :longitude,
                  :last_tracked_at
  end
  json.categories user.categories.map(&:name).join(', ')
  json.in_favorites current_user.in_favorites?(user) if user_signed_in?
end
