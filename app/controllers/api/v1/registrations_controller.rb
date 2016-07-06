module Api
  module V1
    class RegistrationsController < Api::V1::V1Controller
      resource_description do
        short 'User Registration'
      end

      api! 'Register user'
      description <<-EOS
        ## Description
        Users registration.
        Return code 200 and usr data if user successfuly created.
      EOS
      param :user, Hash, desc: 'User info', required: true do
        param :role, %w(beautician user), desc: 'Role. User by default.'
        param :email, String, desc: 'Email', required: true
        param :password, String, desc: 'Password', required: true
        param :name, String, desc: 'Name', required: true
        param :surname, String, desc: 'Surname'
        param :username, String,
              desc: 'Username. Starts with @, without spaces', required: true
        param :sex, %w(male female other), desc: 'Sex. Other by default.'
        param :facebook_token, String, desc: 'Facebook token to sign up with FB'
      end
      example <<-EOS
        User:
        {
          "id": 36,
          "name": "Name",
          "surname": "Surname",
          "username": "@sulyanoff18",
          "sex": "other",
          "bio": null,
          "profile_picture_url": null,
          "rating": 0,
          "created_at": "2016-07-06T07:49:25.050+02:00"
        }

        Beautician:
        {
          "id": 35,
          "name": "Name",
          "surname": "Surname",
          "username": "@sulyanoff4",
          "sex": "other",
          "bio": null,
          "profile_picture_url": null,
          "rating": 0,
          "created_at": "2016-07-06T07:48:00.176+02:00",
          "categories": "",
          "settings_beautician": {
            "instant_booking": false,
            "advance_booking": false,
            "mobile": false,
            "office": false
          },
          "pictures": [],
          "reviews": []
        }
      EOS

      def create
        @user = User.new(user_params)
        # user can't register as admin via API
        @user.role = :user if @user.admin?
        @user.active = true unless @user.beautician?
        @user.send_welcome_message if @user.save
        respond_with @user
      end

      private

      def user_params
        params.require(:user)
              .permit(:role, :email, :password, :name, :surname, :username,
                      :sex, :language_id, :facebook_token)
      end
    end
  end
end
