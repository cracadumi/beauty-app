module Api
  module V1
    class AvailabilitiesController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_user, only: [:index]
      before_action :set_availability, only: [:update]

      resource_description do
        short 'Availabilities'
      end

      api :GET, '/v1/users/:id/availabilities', 'Availabilities of beautician'
      description <<-EOS
        ## Description
        Availabilities of beautician
      EOS
      example <<-EOS
      [
        {
          "id": 10,
          "day": "sunday",
          "starts_at_time": "09:00",
          "ends_at_time": "17:00",
          "working_day": true
        }
      ]
      EOS

      def index
        @availabilities = @user.settings_beautician.availabilities
        respond_with @availabilities
      end

      api :PUT, '/v1/availabilities/:id', 'Update Availability'
      description <<-EOS
        ## Description
        Update availability data.
        Returns 204 code and empty body.
      EOS
      param :availability, Hash, desc: 'Availability info', required: true do
        param :starts_at, String, desc: 'Starts at, ex: 08:00'
        param :ends_at, String, desc: 'Ends at, ex: 17:00'
        param :working_day, :bool, desc: 'Working day?'
      end

      def update
        @availability.update_attributes(availability_params)
        respond_with @availability
      end

      private

      def availability_params
        params.require(:availability).permit(:starts_at, :ends_at, :working_day)
      end

      def set_user
        @user = User.find_by!(id: params[:id])
      end

      def set_availability
        @availability = Availability.find_by(id: params[:id])
      end
    end
  end
end
