json.array! @bookings do |booking|
  json.extract! booking, :id, :status, :datetime_at, :instant, :items

  json.beautician do
    json.extract! booking.beautician, :id, :name, :surname, :rating

    json.profile_picture do
      json.s70 booking.beautician.profile_picture.url(:s70)
    end if booking.beautician.profile_picture?
  end
end
