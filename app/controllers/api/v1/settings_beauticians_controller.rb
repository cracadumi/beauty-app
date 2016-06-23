module Api
  module V1
    class SettingsBeauticiansController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_settings_beautician, only: [:show]

      resource_description do
        short 'SettingsBeauticians'
      end

      api :GET, '/v1/settings_beauticians/:id', 'Show SettingsBeauticians'
      description <<-EOS
        ## Description
        Show SettingsBeautician data
      EOS
      example <<-EOS
        {
          "instant_booking": true,
          "advance_booking": true,
          "mobile": true,
          "office": true,
          "office_address": {
            "street": "123",
            "postcode": 123,
            "city": "123",
            "state": "",
            "latitude": 37.5700969,
            "longitude": 126.9913845,
            "country": "FR"
          },
          "availabilities": [
            {
              "day": "sunday",
              "starts_at_time": "09:00",
              "ends_at_time": "17:00",
              "working_day": true
            }
          ]
        }
      EOS

      def show
        respond_with @settings_beautician
      end

      private

      def set_settings_beautician
        @user = params[:id] ? User.find_by(id: params[:id]) : current_user
        @settings_beautician = @user.settings_beautician
      end
    end
  end
end
