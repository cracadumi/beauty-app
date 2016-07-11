json.extract! user, :id, :name, :surname, :username, :sex, :bio, :rating,
              :created_at

json.profile_picture do
  json.s70 user.profile_picture.url(:s70)
end if user.profile_picture?

if current_user == user
  json.extract! user, :role, :email, :phone_number, :dob_on, :active

  json.language do
    json.id user.language.id
    json.name user.language.name
  end if user.language
end

if user.beautician?
  if user.recently_tracked?
    json.extract! user, :latitude, :longitude,
                  :last_tracked_at
  end
  json.categories user.categories.map(&:name).join(', ')
  json.favorite current_user.in_favorites?(user) if user_signed_in?
  json.has_booking current_user.has_booking?(user) if user_signed_in?

  json.settings_beautician do
    json.partial! user.settings_beautician
  end

  json.pictures user.pictures, :id, :title, :description, :picture_url

  json.reviews do
    json.partial! 'api/v1/reviews/review',
                  collection: user.reviews_of_me.visible, as: :review
  end
end
