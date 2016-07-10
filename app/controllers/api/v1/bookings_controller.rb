module Api
  module V1
    class BookingsController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_booking, only: [:update]

      resource_description do
        short 'Booking'
      end

      def_param_group :booking do
        param :booking, Hash, desc: 'Booking info', required: true do
          param :beautician_id, Integer, desc: 'Beautician ID', required: true
          param :service_ids, Array, desc: 'Service IDs', required: true
          param :payment_method_id, Integer, desc: 'PaymentMethod ID',
                required: true
          param :notes, String, desc: 'Notes'
          param :instant, :bool, desc: 'Instant'
          param :datetime_at, DateTime,
                desc: 'Date and time, format YYYY-MM-DD HH:MM'
          param :address_attributes, Hash, 'Address info', required: true do
            param :postcode, Integer, desc: 'Postcode'
            param :street, String, desc: 'Street'
            param :city, String, desc: 'City'
            param :state, String, desc: 'State'
            param :country, String, desc: 'Country code (e.g. FR, GB, DE)'
          end
        end
      end

      api :POST, '/v1/bookings', 'Add booking'
      description <<-EOS
        ## Description
        Add booking.
        Returns 204 code and booking data.
      EOS
      param_group :booking
      example <<-EOS
      {
        "id": 15,
        "status": "pending",
        "user_id": 2,
        "beautician_id": 20,
        "datetime_at": "2016-06-10T17:42:00.000+02:00",
        "pay_to_beautician": "102.02",
        "total_price": "112.222",
        "notes": "Test1",
        "unavailability_explanation": null,
        "checked_in": false,
        "expires_at": "2016-07-11T12:47:47.583+02:00",
        "instant": false,
        "reschedule_at": null,
        "created_at": "2016-07-10T12:47:47.575+02:00",
        "items": "Manicure, Cut off",
        "payment_method_id": 42
      }
      EOS

      def create
        @booking = current_user.bookings.create(booking_params)
        # TODO: charge payment
        # if payment doesn't go through, return error message
        respond_with @booking
      end

      private

      def booking_params
        params.require(:booking)
            .permit(:beautician_id, :payment_method_id, :notes, :instant,
                    :datetime_at, service_ids: [],
                    address_attributes: [:postcode, :street, :city, :state,
                                         :country])
      end

      def set_booking
        @booking = Booking.find_by(id: params[:id])
      end
    end
  end
end
