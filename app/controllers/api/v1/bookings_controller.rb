module Api
  module V1
    class BookingsController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_booking, only: [:show, :cancel]

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
      param :status, %w(pending accepted expired refused completed canceled
                        rescheduled), desc: 'Status'
      example <<-EOS
      User see:
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

      Beautician see:
      [
        {
          "id": 16,
          "status": "pending",
          "datetime_at": "2016-06-10T17:42:00.000+02:00",
          "instant": false,
          "items": "Manicure, Cut off",
          "user": {
            "id": 2,
            "name": "Updated",
            "surname": "Sername",
            "rating": 1,
            "profile_picture": {
              "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/2/s70_file.jpeg"
            }
          }
        }
      ]
      EOS

      def index
        @bookings = current_user.beautician? ?
            current_user.bookings_of_me : current_user.bookings
        @bookings = @bookings.where(status: params[:status]) if params[:status]
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
      User see:
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

      Beautician see:
      {
        "id": 16,
        "status": "pending",
        "user_id": 2,
        "datetime_at": "2016-06-10T17:42:00.000+02:00",
        "instant": false,
        "items": "Manicure, Cut off",
        "notes": "Test1",
        "created_at": "2016-07-10T15:47:16.631+02:00",
        "expires_at": "2016-07-11T15:47:16.640+02:00",
        "reschedule_at": null,
        "address": {
          "id": 74,
          "street": "222",
          "postcode": 111,
          "city": "333",
          "state": "444",
          "latitude": 38.3955836,
          "longitude": 27.092579,
          "country": "FR"
        },
        "user": {
          "id": 2,
          "name": "Updated",
          "surname": "Sername",
          "rating": 1,
          "profile_picture": {
            "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/2/s70_file.jpeg"
          }
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
      User see:
      {
        "id": 16,
        "status": "canceled",
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

      Beautician see:
      {
        "id": 18,
        "status": "accepted",
        "user_id": 2,
        "datetime_at": "2016-06-20T17:42:00.000+02:00",
        "instant": false,
        "items": "Manicure, Cut off",
        "notes": "Test1",
        "created_at": "2016-07-10T16:03:44.771+02:00",
        "expires_at": "2016-07-11T16:03:44.780+02:00",
        "reschedule_at": null,
        "address": {
          "id": 75,
          "street": "222",
          "postcode": 111,
          "city": "333",
          "state": "444",
          "latitude": 38.3955836,
          "longitude": 27.092579,
          "country": "FR"
        },
        "user": {
          "id": 2,
          "name": "Updated",
          "surname": "Sername",
          "rating": 1,
          "profile_picture": {
            "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/2/s70_file.jpeg"
          }
        }
      }
      EOS

      def last_unreviewed
        bookings = current_user.beautician? ?
            current_user.bookings_of_me : current_user.bookings
        @booking = bookings.order(created_at: :asc).where
                           .not(id: Review.all.pluck(:booking_id)).first
        head(:not_found) && return unless @booking
        respond_with @booking
      end

      api :PUT, '/v1/bookings/:id/cancel', 'Cancel booking'
      description <<-EOS
        ## Description
        Cancel booking.
        Returns 204 code and booking data.
        Куегкт 422 if booking can't be canceled.
      EOS
      example <<-EOS
      User see:
      {
        "id": 16,
        "status": "canceled",
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

      Beautician see:
      {
        "id": 18,
        "status": "canceled",
        "user_id": 2,
        "datetime_at": "2016-06-20T17:42:00.000+02:00",
        "instant": false,
        "items": "Manicure, Cut off",
        "notes": "Test1",
        "created_at": "2016-07-10T16:03:44.771+02:00",
        "expires_at": "2016-07-11T16:03:44.780+02:00",
        "reschedule_at": null,
        "address": {
          "id": 75,
          "street": "222",
          "postcode": 111,
          "city": "333",
          "state": "444",
          "latitude": 38.3955836,
          "longitude": 27.092579,
          "country": "FR"
        },
        "user": {
          "id": 2,
          "name": "Updated",
          "surname": "Sername",
          "rating": 1,
          "profile_picture": {
            "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/2/s70_file.jpeg"
          }
        }
      }
      EOS

      def cancel
        head(:unprocessable_entity) && return unless @booking.may_cancel?
        @booking.cancel!
        respond_with @booking
      end

      api :PUT, '/v1/bookings/:id/accept', 'Accept booking/reschedule'
      description <<-EOS
        ## Description
        Accept booking/reschedule.
        Return 204 code and booking data.
        Return 422 if booking can't be rescheduled.
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

      def accept
        head(:unprocessable_entity) && return unless @booking.may_accept?
        if @booking.rescheduled?
          @booking.update_attributes datetime_at: @booking.reschedule_at,
                                     reschedule_at: nil
        end
        @booking.accept!
        respond_with @booking
      end

      api :PUT, '/v1/bookings/:id/refuse', 'Refuse pending booking'
      description <<-EOS
        ## Description
        Refuse pending booking.
        Return 204 code and booking data.
        Return 422 if booking can't be refused.
      EOS
      example <<-EOS
      {
        "id": 16,
        "status": "refused",
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

      def refuse
        head(:unprocessable_entity) && return unless @booking.may_refuse?
        @booking.refuse!
        respond_with @booking
      end

      api :PUT, '/v1/bookings/:id/check_in', 'Check in accepted booking'
      description <<-EOS
        ## Description
        Check in accepted booking.
        Return 204 code and booking data.
        Return 422 if booking can't be checked in.
      EOS
      example <<-EOS
      {
        "id": 16,
        "status": "completed",
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

      def check_in
        head(:unprocessable_entity) && return unless @booking.may_check_in?
        @booking.check_in!
        respond_with @booking
      end

      api :PUT, '/v1/bookings/:id/reschedule', 'Reschedule pending booking'
      description <<-EOS
        ## Description
        Reschedule pending booking.
        Return 204 code and booking data.
        Return 422 if booking can't be rescheduled.
      EOS
      param :booking, Hash, desc: 'Booking info', required: true do
        param :reschedule_at, DateTime,
              desc: 'Reschedule Date and time, format YYYY-MM-DD HH:MM'
      end
      example <<-EOS
      {
        "id": 16,
        "status": "rescheduled",
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

      def reschedule
        head(:unprocessable_entity) && return unless @booking.may_reschedule? &&
                                                     reschedule_params[:reschedule_at]
        @booking.update_attribute :reschedule_at, reschedule_params[:reschedule_at]
        @booking.reschedule!
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

      def reschedule_params
        params.require(:booking).permit(:reschedule_at)
      end

      def set_booking
        @booking = Booking.find_by(id: params[:id])
      end
    end
  end
end
