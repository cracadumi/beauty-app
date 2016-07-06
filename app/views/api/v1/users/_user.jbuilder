json.extract! user, :id, :name, :surname, :username, :sex, :bio,
              :profile_picture_url, :rating, :created_at

if current_user == user
  json.extract! user, :role, :email, :phone_number, :dob_on, :active
end

if user.beautician?
  if user.recently_tracked?
    json.extract! user, :latitude, :longitude,
                  :last_tracked_at
  end
  json.categories user.categories.map(&:name).join(', ')
  json.favorite current_user.in_favorites?(user) if user_signed_in?
  # json.has_booking current_user.has_booking?(user) if user_signed_in?

  json.settings_beautician do
    json.partial! user.settings_beautician
  end

  json.pictures user.pictures, :id, :title, :description, :picture_url

  json.reviews do
    json.partial! 'api/v1/reviews/review', collection: user.reviews.visible,
                                           as: :review
  end
end
