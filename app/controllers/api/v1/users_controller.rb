module Api
  module V1
    class UsersController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_user, only: [:show]

      resource_description do
        short 'Users'
      end

      api :GET, '/v1/users', 'Search users'
      description <<-EOS
        ## Description
        Search users
      EOS
      param :latitude, Float, desc: 'Latitude', require: true
      param :longitude, Float, desc: 'Longitude', require: true
      param :distance, Integer, desc: 'Distance, km. Default 15.'
      param :category_id, Integer, desc: 'Category ID'
      param :max_price, Integer, desc: 'Max service price'
      param :min_rating, Integer, desc: 'Min rating'
      example <<-EOS
        [
          {
            "id": 20,
            "name": "Beautician",
            "surname": "Test",
            "rating": 0,
            "reviews_count": 0,
            "in_favorites": false,
            "instant_booking": false,
            "office": false,
            "mobile": false,
            "latitude": 1.11,
            "longitude": 2.22,
            "last_tracked_at": "2016-06-28T11:15:00.000+02:00"
          }
        ]
      EOS

      def index
        @users = User.beauticians.recently_tracked
        if params[:category_id].present?
          @users = @users.of_category(params[:category_id])
        end
        if params[:max_price].present?
          @users = @users.with_max_price(params[:max_price])
        end
        if params[:min_rating].present?
          @users = @users.with_min_rating(params[:min_rating])
        end
        @users = @users.nearest(params[:latitude], params[:longitude],
                                params[:distance] || 15)
        respond_with @user
      end

      api! 'Show user'
      description <<-EOS
        ## Description
        Show user data
      EOS
      example <<-EOS
        {
          "id": 20,
          "name": "Beautician",
          "surname": "Test",
          "username": "@beautician",
          "sex": "other",
          "bio": "Hi all",
          "profile_picture": {
            "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/2/s70_file.jpeg"
          },
          "rating": 4,
          "created_at": "2016-06-14T11:28:46.818+02:00",
          "latitude": 1.11,
          "longitude": 2.22,
          "last_tracked_at": "2016-07-06T07:45:54.503+02:00",
          "categories": "Nails",
          "favorite": false,
          "has_booking": true,
          "settings_beautician": {
            "instant_booking": true,
            "advance_booking": true,
            "mobile": true,
            "office": true,
            "office_address": {
              "id": 54,
              "street": "11",
              "postcode": 22,
              "city": "33",
              "state": "44",
              "latitude": 30.0447014,
              "longitude": 31.0337914,
              "country": "FR"
            },
            "availabilities": []
          },
          "pictures": [
            {
              "id": 1,
              "title": "Test",
              "description": "la-la",
              "picture_url": "http://yastatic.net/morda-logo/i/bender/logo.svg"
            }
          ],
          "reviews": [
            {
              "id": 2,
              "booking_id": 9,
              "user_id": 20,
              "rating": 4,
              "comment": "Good",
              "author": {
                "id": 2,
                "name": "Updated",
                "surname": "Sername",
                "profile_picture": {
                  "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/2/s70_file.jpeg"
                },
              }
            }
          ]
        }
      EOS

      def show
      end

      private

      def set_user
        @user = User.find_by(id: params[:id])
      end
    end
  end
end
