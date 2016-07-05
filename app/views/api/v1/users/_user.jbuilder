json.extract! user, :id, :name, :surname, :username, :role, :email, :sex, :bio,
              :phone_number, :dob_on, :profile_picture_url, :active,
              :rating, :created_at

if user.beautician?
  if user.location_last_updated_at.present? &&
     Time.zone.now - user.location_last_updated_at <= 5.minutes
    json.extract! user, :latitude, :longitude,
                  :location_last_updated_at
  end
  json.categories user.categories.map(&:name).join(', ')
  json.in_favorites current_user.in_favorites?(user) if user_signed_in?
end
