module Api
  module V1
    class ServicesController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      before_action :set_services, only: [:index]
      load_and_authorize_resource

      resource_description do
        short 'Services'
      end

      api :GET, '/v1/services', 'Services list'
      description <<-EOS
        ## Description
        List of services
      EOS
      param :latitude, Float, desc: 'Latitude'
      param :longitude, Float, desc: 'Longitude'
      param :distance, Integer, desc: 'Distance, m.'
      param :max_price, Integer, desc: 'Max price'
      param :category_id, Integer, desc: 'Category ID'
      param :min_rating, Integer, desc: 'Min rating of beautician'
      example <<-EOS
        [
          {
            "id": 3,
            "price": "1.22",
            "name": "Manicure",
            "beautician_id": 20
          }
        ]
      EOS

      def index
        respond_with @services
      end

      private

      def set_services
        @services = if params[:beautician_id].present?
                      User.active.find_by!(id: params[:beautician_id]).services
                    elsif params[:booking_id].present?
                      Booking.find_by!(id: params[:booking_id]).services
                    else
                      Service.active
                    end
        filter_services
      end

      def filter_services
        if params[:category_id].present?
          @services = @services.of_category(params[:category_id])
        end
        if params[:max_price].present?
          @services = @services.with_max_price(params[:max_price])
        end
        if params[:min_rating].present?
          @services = @services.with_min_rating(params[:min_rating])
        end
        if params[:latitude] && params[:longitude] && params[:distance]
          @services = @services.nearest(params[:latitude], params[:longitude],
                                        params[:distance].to_f / 1000.0)
        end
      end
    end
  end
end
