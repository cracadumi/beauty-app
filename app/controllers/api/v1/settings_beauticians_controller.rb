module Api
  module V1
    class SettingsBeauticiansController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_settings_beautician, only: [:show]

      resource_description do
        short 'SettingsBeauticians'
      end

      api :GET, '/v1/my/settings_beauticians', 'Show My SettingsBeauticians'
      description <<-EOS
        ## Description
        Show SettingsBeautician data of current user
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

      def my
      end

      api :GET, '/v1/users/:id/settings_beauticians', 'Show SettingsBeauticians'
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

      api :PUT, '/v1/settings_beauticians/:id', 'Update SettingsBeauticians'
      description <<-EOS
        ## Description
        Update SettingsBeautician data
      EOS
      param :settings_beautician, Hash, desc: 'SettingBeautician info',
                                        required: true do
        param :instant_booking, :bool, desc: 'Instant Booking'
        param :advance_booking, :bool, desc: 'Advance Booking'
        param :mobile, :bool, desc: 'Mobile'
        param :office, :bool, desc: 'Office'
      end
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

      def update
        @settings_beautician.update_attributes(settings_beautician_params)
        respond_with @settings_beautician
      end

      private

      def settings_beautician_params
        params.require(:settings_beautician)
              .permit(:instant_booking, :advance_booking, :mobile, :office)
      end

      def set_settings_beautician
        @user = params[:id] ? User.find_by(id: params[:id]) : current_user
        @settings_beautician = @user.settings_beautician
      end
    end
  end
end
