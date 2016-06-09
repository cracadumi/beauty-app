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
        param :surname, String, desc: 'Surname', required: true
        param :username, String, desc: 'Username. Starts with @, without spaces'
        param :sex, %w(male female other), desc: 'Sex. Other by default.'
      end
      example <<-EOS
        {
          "id": 10,
          "name": "Name",
          "surname": "Surname",
          "username": "@adminoff",
          "role": "user",
          "email": "em6@il.ru",
          "sex": "other",
          "bio": null,
          "phone_number": null,
          "dob_on": null,
          "profile_picture_url": null,
          "active": true,
          "archived": false,
          "latitude": null,
          "longitude": null,
          "available": false,
          "rating": 0
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
        params.require(:user).permit(:role, :email, :password, :name, :surname,
                                     :username, :sex)
      end
    end
  end
end
