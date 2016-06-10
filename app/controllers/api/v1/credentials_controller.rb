module Api
  module V1
    class CredentialsController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      before_action :set_user

      resource_description do
        short 'Current user'
      end

      api :GET, '/v1/me', 'Show current user'
      description <<-EOS
        ## Description
        Show data of current user
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

      api :PUT, '/v1/me', 'Update current user'
      description <<-EOS
        ## Description
        Updates current user
        Returns code 204 if user successfully updated.
      EOS
      param :user, Hash, desc: 'User info', required: true do
        param :email, String, desc: 'Email', required: true
        param :name, String, desc: 'Name', required: true
        param :surname, String, desc: 'Surname', required: true
        param :username, String, desc: 'Username'
        param :sex, %w(male female other), desc: 'Sex. Other by default.'
        param :bio, String, desc: 'Bio'
        param :phone_number, User::PHONE_REGEX, desc: 'Phone'
        param :dob_on, String, desc: 'Date of birth'
        param :profile_picture, ActionDispatch::Http::UploadedFile,
              desc: 'Photo image'
      end

      def update
        @user.update_attributes(user_params)
        respond_with @user
      end

      api :DELETE, '/v1/me', 'Archive account'
      description <<-EOS
        ## Description
        Updates current user
        Returns code 204 if user successfully archived.
      EOS

      def destroy
        @user.update_attribute(:archived, true)
        @user.tokens.update_all revoked_at: Time.zone.now
        respond_with @user
      end

      private

      def user_params
        params.require(:user)
              .permit(:email, :name, :surname, :username, :sex,
                      :bio, :phone_number, :dob_on, :profile_picture,
                      :password)
      end

      def set_user
        @user = current_user
      end
    end
  end
end
