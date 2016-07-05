json.array! @users do |user|
  json.extract! user, :id, :name, :surname, :rating, :reviews_count

  json.in_favorites current_user.in_favorites?(user) if user_signed_in?

  if user.settings_beautician
    json.instant_booking user.settings_beautician.instant_booking
    json.office user.settings_beautician.office
    json.mobile user.settings_beautician.mobile
  end

  if user.recently_tracked?
    json.extract! user, :latitude, :longitude,
                  :last_tracked_at
  end
end
