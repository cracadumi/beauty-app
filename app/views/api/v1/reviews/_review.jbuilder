json.extract! review, :id, :booking_id, :user_id, :rating, :comment

json.author do
  json.extract! review.author, :id, :name, :surname
  json.profile_picture do
    json.s70 review.author.profile_picture.url(:s70)
  end if review.author.profile_picture?
end
