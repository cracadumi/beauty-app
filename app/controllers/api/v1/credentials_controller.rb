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
        "id": 2,
        "name": "Updated",
        "surname": "Sername",
        "username": "@username",
        "sex": "male",
        "bio": "About me",
        "rating": 0,
        "created_at": "2016-06-06T17:26:37.093+02:00",
        "profile_picture": {
          "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/2/s70_file.jpeg"
        },
        "role": "user",
        "email": "em1@il.ru",
        "phone_number": "1234567890",
        "dob_on": "2011-03-02",
        "active": false,
        "language": {
          "id": 1,
          "name": "Russian"
        }
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
        param :name, String, desc: 'Name', required: true
        param :surname, String, desc: 'Surname'
        param :sex, %w(male female other), desc: 'Sex. Other by default.'
        param :bio, String, desc: 'Bio'
        param :phone_number, User::PHONE_REGEX, desc: 'Phone'
        param :dob_on, String, desc: 'Date of birth'
        param :profile_picture, String, desc: 'Photo image, base64'
        param :password, String, desc: 'New password'
        param :current_password, String,
              desc: 'Current password. Required if password present.'
        param :language_id, Integer, desc: 'Language ID'
        param :latitude, Float, desc: 'Latitude'
        param :longitude, Float, desc: 'Longitude'
      end

      def update
        Rails.logger.info "user_params=#{user_params.inspect}"
        if user_params[:password].present?
          @user.update_with_password(user_params)
        else
          @user.update_attributes(user_params)
        end
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
              .permit(:name, :surname, :sex, :bio, :phone_number, :dob_on,
                      :profile_picture, :password, :current_password,
                      :language_id, :latitude, :longitude).tap do |e|
          if e['latitude'].present? || e['longitude'].present?
            e['last_tracked_at'] = Time.zone.now
          end
        end
      end

      def set_user
        @user = current_user
      end
    end
  end
end
