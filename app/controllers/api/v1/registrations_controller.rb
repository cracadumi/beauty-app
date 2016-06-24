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
        {
          "id": 31,
          "name": "Name",
          "surname": "Surname",
          "username": "@sulyanoff7",
          "role": "user",
          "email": "em15@il.ru",
          "sex": "other",
          "bio": null,
          "phone_number": null,
          "dob_on": null,
          "profile_picture_url": null,
          "active": true,
          "rating": 0,
          "created_at": "2016-06-24T01:04:36.390Z",
          "latitude": null,
          "longitude": null,
          "location_last_updated_at": null
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
