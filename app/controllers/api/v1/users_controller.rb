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
          "id": 10,
          "name": "Name",
          "surname": "Sername",
          "username": "@username",
          "role": "user",
          "email": "em1@il.ru",
          "sex": "male",
          "bio": "About me",
          "phone_number": "1234567890",
          "dob_on": "2011-03-02",
          "profile_picture_url": "/uploads/user/profile_picture/2/eye22n.jpeg",
          "active": true,
          "latitude": 1.123,
          "longitude": 2.345,
          "rating": 0,
          "created_at": "2016-06-06T15:26:37.093Z",
          "last_tracked_at": null
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
