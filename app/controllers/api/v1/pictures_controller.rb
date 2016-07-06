module Api
  module V1
    class PicturesController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource
      before_action :set_parent, only: [:index, :create]
      before_action :set_picture, only: [:show, :destroy]
      before_action :authorize_parent, only: [:create]

      resource_description do
        short 'Pictures'
      end

      api :GET, '/v1/me/pitures', 'List of Pictures'
      description <<-EOS
        ## Description
        List of pictures.
      EOS
      param :title, String, desc: 'Title'
      example <<-EOS
        [
          {
            "id": 1,
            "title": "Test",
            "description": "la-la",
            "picture_url": "http://yastatic.net/morda-logo/i/bender/logo.svg"
          }
        ]
      EOS

      def index
        @pictures = @parent.pictures.order :id
        respond_with @picture
      end

      api! 'Add Picture'
      description <<-EOS
        ## Description
        Add new picture.
      EOS
      param :picture, Hash, desc: 'Picture info', required: true do
        param :title, String, desc: 'Title'
        param :description, String, desc: 'Description'
        param :picture_url, String, desc: 'Picture URL'
      end
      example <<-EOS
        {
          "id": 8,
          "title": "Test 1",
          "description": "A tree",
          "picture_url": "http://yastatic.net/morda-logo/i/bender/logo.svg"
        }
      EOS

      def create
        @picture = @parent.pictures.create(picture_params)
        respond_with @picture
      end

      api! 'View Picture'
      description <<-EOS
        ## Description
        Returns picture data.
      EOS
      example <<-EOS
        {
          "id": 8,
          "title": "Test 1",
          "description": "A tree",
          "picture_url": "http://yastatic.net/morda-logo/i/bender/logo.svg"
        }
      EOS

      def show
        respond_with @picture
      end

      api! 'Destroy Picture'
      description <<-EOS
        ## Description
        Destroys the picture.
      EOS

      def destroy
        @picture.destroy
        respond_with @picture
      end

      private

      def picture_params
        params.require(:picture)
              .permit(:title, :description, :picture_url)
      end

      # rubocop:disable Metrics/AbcSize
      def set_parent
        if params[:model_name]
          parent_class = params[:model_name].constantize
          parent_foreing_key = params[:model_name].foreign_key
        end

        if params[:model_name] == 'User' && params[parent_foreing_key].present?
          @parent = parent_class.find(params[parent_foreing_key])
        else
          @parent = current_user
        end
      end
      # rubocop:enable Metrics/AbcSize

      def authorize_parent
        authorize! :update, @parent
      end

      def set_picture
        @picture = Picture.find_by(id: params[:id])
      end
    end
  end
end
