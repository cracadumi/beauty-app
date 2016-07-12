module Api
  module V1
    class ReviewsController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_review, only: [:show]
      before_action :set_booking, only: [:create]

      resource_description do
        short 'Review'
      end

      api :GET, '/v1/reviews', 'Reviews current user left'
      description <<-EOS
        ## Description
        Reviews current user left
      EOS
      example <<-EOS
      [
        {
          "id": 2,
          "booking_id": 9,
          "rating": 3,
          "comment": "Good",
          "author": {
            "id": 2,
            "name": "Updated",
            "surname": "Sername",
            "profile_picture": {
              "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/2/s70_file.jpeg"
            }
          },
          "beautician": {
            "id": 20,
            "name": "Beautician",
            "surname": "Test",
            "profile_picture": {
              "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/20/s70_eye22n.jpeg"
            }
          }
        }
      ]
      EOS

      def index
        @reviews = current_user.reviews
        respond_with @reviews
      end

      api :POST, '/v1/bookings/:id/reviews', 'Add review'
      description <<-EOS
        ## Description
        Add review.
        Returns 204 code and review data.
      EOS
      param :review, Hash, desc: 'Review info', required: true do
        param :rating, Integer, desc: 'Rating, 1-5', required: true
        param :comment, String, desc: 'Comment. Required if rating <= 2'
      end
      example <<-EOS
      {
        "id": 16,
        "status": "pending",
        "user_id": 2,
        "datetime_at": "2016-06-10T17:42:00.000+02:00",
        "instant": false,
        "items": "Manicure, Cut off",
        "beautician": {
          "id": 20,
          "name": "Beautician",
          "surname": "Test",
          "rating": 2,
          "profile_picture": {
            "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/20/s70_eye22n.jpeg"
          }
        },
        "address": {
          "id": 74,
          "street": "222",
          "postcode": 111,
          "city": "333",
          "state": "444",
          "latitude": 38.3955836,
          "longitude": 27.092579,
          "country": "FR"
        }
      }
      EOS

      def create
        @review = @booking.reviews.build(review_params)
        @review.author = current_user
        @review.save
        respond_with @review
      end

      api :GET, '/v1/reviews/:id', 'Show Review'
      description <<-EOS
        ## Description
        Show Review
      EOS
      example <<-EOS
      {
        "id": 16,
        "status": "pending",
        "user_id": 2,
        "datetime_at": "2016-06-10T17:42:00.000+02:00",
        "instant": false,
        "items": "Manicure, Cut off",
        "beautician": {
          "id": 20,
          "name": "Beautician",
          "surname": "Test",
          "rating": 2,
          "profile_picture": {
            "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/20/s70_eye22n.jpeg"
          }
        },
        "address": {
          "id": 74,
          "street": "222",
          "postcode": 111,
          "city": "333",
          "state": "444",
          "latitude": 38.3955836,
          "longitude": 27.092579,
          "country": "FR"
        }
      }
      EOS

      def show
        respond_with @review
      end

      private

      def review_params
        params.require(:review).permit(:booking_id, :rating, :comment)
      end

      def set_review
        @review = Review.find_by(id: params[:id])
      end

      def set_booking
        @booking = Booking.find_by(id: params[:booking_id])
      end
    end
  end
end
