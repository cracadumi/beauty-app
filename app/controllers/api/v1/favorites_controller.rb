module Api
  module V1
    class FavoritesController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      before_action :set_favorite, only: [:destroy]
      load_and_authorize_resource

      resource_description do
        short 'Favorites'
      end

      api :GET, '/v1/favorites', 'Favorites of current user'
      description <<-EOS
        ## Description
        Favorites of current user
      EOS
      example <<-EOS
        [
          {
            "id": 1,
            "beautician": {
              "id": 20,
              "name": "Beautician",
              "surname": "Test",
              "profile_picture": {
                "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/20/s70_eye22n.jpeg"
              },
              "categories": "Nails"
            }
          }
        ]
      EOS

      def index
        @favorites = current_user.favorites
        respond_with @favorites
      end

      api :POST, '/v1/favorites', 'Add to favorites'
      description <<-EOS
        ## Description
        Add to favorites.
        Returns 204 code and favorite data.
      EOS
      param :favorite, Hash, desc: 'Favorite info', required: true do
        param :beautician_id, String, desc: 'Beautician ID'
      end
      example <<-EOS
      {
        "id": 3,
        "beautician": {
          "id": 20,
          "name": "Beautician",
          "surname": "Test",
          "profile_picture": {
            "s70": "https://beautyapp-development.s3.amazonaws.com/uploads/user/profile_picture/20/s70_eye22n.jpeg"
          },
          "categories": "Nails"
        }
      }
      EOS

      def create
        @favorite = current_user.favorites.create(favorite_params)
        respond_with @favorite
      end

      api :DELETE, '/v1/favorites/:id', 'Remove from favorites'
      description <<-EOS
        ## Description
        Remove from favorites.
        Returns 204 code.
      EOS

      def destroy
        @favorite.destroy
        respond_with @favorite
      end

      private

      def favorite_params
        params.require(:favorite).permit(:beautician_id)
      end

      def set_favorite
        @favorite = Favorite.find_by!(id: params[:id])
      end
    end
  end
end
