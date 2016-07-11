module Api
  module V1
    class BookingsController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_booking, only: [:show]

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

      api :GET, '/v1/bookings', 'Bookings of current user'
      description <<-EOS
        ## Description
        Bookings of current user
      EOS
      example <<-EOS
      [
        {
          "id": 16,
          "status": "accepted",
          "datetime_at": "2016-06-10T17:42:00.000+02:00",
          "instant": false,
          "items": "Manicure, Cut off",
          "beautician": {
            "id": 20,
            "name": "Beautician",
            "surname": "Test",
            "rating": 3,
            "profile_picture": {
              "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/20/s70_eye22n.jpeg"
            }
          }
        }
      ]
      EOS

      def index
        @bookings = current_user.bookings
        respond_with @bookings
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
        "id": 16,
        "status": "accepted",
        "user_id": 2,
        "datetime_at": "2016-06-10T17:42:00.000+02:00",
        "instant": false,
        "items": "Manicure, Cut off",
        "beautician": {
          "id": 20,
          "name": "Beautician",
          "surname": "Test",
          "rating": 3,
          "profile_picture": {
            "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/20/s70_eye22n.jpeg"
          }
        },
        "address": {
          "id": 71,
          "street": "222",
          "postcode": 111,
          "city": "333",
          "state": "444",
          "latitude": 38.3955836,
          "longitude": 27.092579,
          "country": "FR"
        }
      }
      EOS

      def create
        @booking = current_user.bookings.create(booking_params)
        # TODO: charge payment
        # if payment doesn't go through, return error message
        respond_with @booking
      end

      api :GET, '/v1/bookings/:id', 'Show Booking'
      description <<-EOS
        ## Description
        Show Booking
      EOS
      example <<-EOS
      {
        "id": 16,
        "status": "accepted",
        "user_id": 2,
        "datetime_at": "2016-06-10T17:42:00.000+02:00",
        "instant": false,
        "items": "Manicure, Cut off",
        "beautician": {
          "id": 20,
          "name": "Beautician",
          "surname": "Test",
          "rating": 3,
          "profile_picture": {
            "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/20/s70_eye22n.jpeg"
          }
        },
        "address": {
          "id": 71,
          "street": "222",
          "postcode": 111,
          "city": "333",
          "state": "444",
          "latitude": 38.3955836,
          "longitude": 27.092579,
          "country": "FR"
        }
      }
      EOS

      def show
        respond_with @booking
      end

      api :GET, '/v1/bookings/last_unreviewed',
          'Show oldest booking without review'
      description <<-EOS
        ## Description
        Show oldest booking without review.
        Return 404 error if there is no default payment method.
      EOS
      example <<-EOS
      {
        "id": 16,
        "status": "accepted",
        "user_id": 2,
        "datetime_at": "2016-06-10T17:42:00.000+02:00",
        "instant": false,
        "items": "Manicure, Cut off",
        "beautician": {
          "id": 20,
          "name": "Beautician",
          "surname": "Test",
          "rating": 3,
          "profile_picture": {
            "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/20/s70_eye22n.jpeg"
          }
        },
        "address": {
          "id": 71,
          "street": "222",
          "postcode": 111,
          "city": "333",
          "state": "444",
          "latitude": 38.3955836,
          "longitude": 27.092579,
          "country": "FR"
        }
      }
      EOS

      def last_unreviewed
        @booking = current_user.bookings.order(created_at: :asc).where
                               .not(id: Review.all.pluck(:booking_id)).first
        head(:not_found) && return unless @booking
        respond_with @booking
      end

      private

      def booking_params
        params.require(:booking)
              .permit(:beautician_id, :payment_method_id, :notes, :instant,
                      :datetime_at,
                      service_ids: [], address_attributes: [:postcode, :street,
                                                            :city, :state,
                                                            :country])
      end

      def set_booking
        @booking = Booking.find_by(id: params[:id])
      end
    end
  end
end
