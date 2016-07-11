module Api
  module V1
    class PaymentMethodsController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      before_action :set_payment_method, only: [:set_default, :destroy]
      load_and_authorize_resource

      resource_description do
        short 'Payment methods'
      end

      api :GET, '/v1/payment_methods', 'Payment methods of current user'
      description <<-EOS
        ## Description
        Payment methods of current user
      EOS
      example <<-EOS
      [
        {
          "id": 35,
          "payment_type": "card",
          "last_4_digits": 1234,
          "card_type": "visa",
          "default": true
        }
      ]
      EOS

      def index
        @payment_methods = current_user.payment_methods
        respond_with @payment_methods
      end

      api :GET, '/v1/payment_methods/default',
          'Default payment method of current user'
      description <<-EOS
        ## Description
        Default payment method of current user.
        Return 404 error if there is no default payment method.
      EOS
      example <<-EOS
      {
        "id": 35,
        "payment_type": "card",
        "last_4_digits": 1234,
        "card_type": "visa",
        "default": true
      }
      EOS

      def default
        @payment_method = current_user.payment_methods.find_by(default: true)
        head(:not_found) && return unless @payment_method
        respond_with @payment_method
      end

      api :PUT, '/v1/payment_methods/:id/set_default',
          'Set payment method as default'
      description <<-EOS
        ## Description
        Set payment method as default.
      EOS
      example <<-EOS
      {
        "id": 35,
        "payment_type": "card",
        "last_4_digits": 1234,
        "card_type": "visa",
        "default": true
      }
      EOS

      def set_default
        @payment_method.set_default!
        respond_with @payment_method
      end

      api :POST, '/v1/payment_methods', 'Add payment method'
      description <<-EOS
        ## Description
        Add new payment method.
        Returns 204 code and payment method data.
      EOS
      param :payment_method, Hash, desc: 'Payment method info',
                                   required: true do
        param :payment_type, %w(card), desc: 'Payment type'
        param :last_4_digits, String, desc: 'Last 4 digits'
        param :card_type, %w(visa mastercard), desc: 'Card type'
      end
      example <<-EOS
      {
        "id": 35,
        "payment_type": "card",
        "last_4_digits": 1234,
        "card_type": "visa",
        "default": true
      }
      EOS

      def create
        @payment_method = current_user.payment_methods
                                      .create(payment_method_params)
        respond_with @payment_method
      end

      api :DELETE, '/v1/payment_methods/:id', 'Remove payment method'
      description <<-EOS
        ## Description
        Remove payment method.
        Returns 204 code.
      EOS

      def destroy
        @payment_method.destroy
        respond_with @payment_method
      end

      private

      def payment_method_params
        params.require(:payment_method)
              .permit(:payment_type, :last_4_digits, :card_type)
      end

      def set_payment_method
        @payment_method = PaymentMethod.find_by!(id: params[:id])
      end
    end
  end
end
