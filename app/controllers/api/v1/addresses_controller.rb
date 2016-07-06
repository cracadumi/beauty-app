module Api
  module V1
    class AddressesController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_address, only: [:update]

      resource_description do
        short 'Addresses'
      end

      api :PUT, '/v1/addresses/:id', 'Update Address'
      description <<-EOS
        ## Description
        Update address data.
        Returns 204 code and empty body.
      EOS
      param :address, Hash, desc: 'Address info', required: true do
        param :postcode, Integer, desc: 'Postcode'
        param :street, String, desc: 'Street'
        param :city, String, desc: 'City'
        param :state, String, desc: 'State'
        param :country, String, desc: 'Country code (e.g. FR, GB, DE)'
      end

      def update
        @address.update_attributes(address_params)
        respond_with @address
      end

      private

      def address_params
        params.require(:address)
              .permit(:postcode, :street, :city, :state, :country)
      end

      def set_address
        @address = Address.find_by(id: params[:id])
      end
    end
  end
end
