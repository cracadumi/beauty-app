module Api
  module V1
    class LanguagesController < Api::V1::V1Controller
      before_action :doorkeeper_authorize!
      load_and_authorize_resource

      resource_description do
        short 'Languages'
      end

      api :GET, '/v1/languages', 'Languages list'
      description <<-EOS
        ## Description
        List of languages
      EOS
      example <<-EOS
        [
          {
            "id": 1,
            "name": "Russian",
            "country": "RU",
            "flag_url": ""
          }
        ]
      EOS

      def index
        @languages = Language.all
        respond_with @languages
      end
    end
  end
end
