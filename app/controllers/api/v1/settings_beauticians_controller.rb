module Api
  module V1
    class SettingsBeauticiansController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_my_settings_beautician, only: [:me]
      before_action :set_settings_beautician, only: [:show]

      resource_description do
        short 'SettingsBeauticians'
      end

      api :GET, 'v1/settings_beauticians/me', 'Show My SettingsBeauticians'
      description <<-EOS
        ## Description
        Show SettingsBeautician data of current user
      EOS
      example <<-EOS
        {
          "instant_booking": true,
          "advance_booking": true,
          "mobile": true,
          "office": true
        }
      EOS

      def me
        respond_with @settings_beautician
      end

      api :GET, 'v1/settings_beauticians/:id', 'Show SettingsBeauticians'
      description <<-EOS
        ## Description
        Show SettingsBeautician data
      EOS
      example <<-EOS
        {
          "instant_booking": true,
          "advance_booking": true,
          "mobile": true,
          "office": true
        }
      EOS

      def show
        respond_with @settings_beautician
      end

      private

      def set_my_settings_beautician
        @user = current_user
        @settings_beautician = @user.settings_beautician
      end

      def set_settings_beautician
        @user = User.find_by(id: params[:id])
        @settings_beautician = @user.settings_beautician
      end
    end
  end
end
