module Api
  module V1
    class FavoritesController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      before_action :set_user, only: [:index]
      load_and_authorize_resource

      resource_description do
        short 'Favorites'
      end

      api :GET, '/v1/me/favorites', 'Favorites of current user'
      description <<-EOS
        ## Description
        Favorites of current user
      EOS
      example <<-EOS
        [
        ]
      EOS

      def index
        @favorites = @user.favorites
        respond_with @favorites
      end

      private

      def set_user
        @user = if params[:me]
                  current_user
                else
                  User.find_by!(id: params[:user_id])
                end
      end
    end
  end
end
