json.extract! review, :id, :booking_id, :user_id, :rating, :comment

json.author do
  json.extract! review.author, :id, :name, :surname, :profile_picture_url
end
