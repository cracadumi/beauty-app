module Api
  module V1
    class UsersController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_user, only: [:show]

      resource_description do
        short 'Users'
      end

      api! 'Search user'
      description <<-EOS
        ## Description
        Search users
      EOS
      example <<-EOS

      EOS

      def beauticians
        # TODO: implement
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
          "rating": 0
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
