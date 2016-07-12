json.extract! booking, :id, :status, :user_id, :datetime_at, :instant, :items,
              :notes, :created_at, :expires_at

json.address do
  json.partial! booking.address
end

if current_user == booking.user
  json.beautician do
    json.extract! booking.beautician, :id, :name, :surname, :rating
    json.profile_picture do
      json.s70 booking.beautician.profile_picture.url(:s70)
    end if booking.beautician.profile_picture?
  end
end

if current_user == booking.beautician
  json.user do
    json.extract! booking.user, :id, :name, :surname, :rating
    json.profile_picture do
      json.s70 booking.user.profile_picture.url(:s70)
    end if booking.user.profile_picture?
  end
end
