module Api
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session,
                         if: proc { |c| c.request.format.json? }
    respond_to :json

    before_action :add_allow_credentials_headers

    helper_method :current_user

    rescue_from CanCan::AccessDenied, with: :access_denied

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def options
      head status: 200, 'Access-Control-Allow-Headers' => 'accept, content-type'
    end

    private

    def current_user
      User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def access_denied(exception)
      message = exception.message || 'Access Denied'
      render json: { message: message }, status: 401
    end

    def not_found(exception)
      message = exception.message || 'Not found'
      render json: { message: message }, status: 404
    end

    def add_allow_credentials_headers
      # https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS
      # #section_5
      #
      # Because we want our front-end to send cookies to allow the API to be
      # authenticated (using 'withCredentials' in the XMLHttpRequest), we need
      # to add some headers so the browser will not reject the response
      response.headers['Access-Control-Allow-Origin'] =
        request.headers['Origin'] || '*'
      response.headers['Access-Control-Allow-Credentials'] = 'true'
    end
  end
end
