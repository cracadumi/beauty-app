module Api
  module V1
    class AvailabilitiesController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_availability, only: [:update]

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

      def set_availability
        @availability = Availability.find_by(id: params[:id])
      end
    end
  end
end
