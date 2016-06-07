Apipie.configure do |config|
  config.app_name = 'Beautyapp'
  config.api_base_url = '/api'
  config.doc_base_url = '/apidoc'
  config.reload_controllers = Rails.env.development?
  config.api_controllers_matcher = File.join(Rails.root, 'app', 'controllers',
                                             'api', '**', '**')
  config.api_routes = Rails.application.routes
  config.default_version = 'V1'
  config.validate = true
  config.app_info['V1'] = <<-EOS
    ## OAuth authorisation by email
    POST **/oauth/token** with parameters
    *   grant_type=password
    *   username – User email
    *   password – User password

    ## OAuth authorisation by FB token
    POST **/oauth/token** with parameters
    *   grant_type=assertion
    *   assertion – FB access token

    Required permissions: **email**, **user_about_me**, **user_birthday**.

    Response example:
    *   {
    *     "access_token" : "93eea114d283b416e2e9eb152fcb99b46392a1c635ab971753",
    *     "created_at" : 1455882679,
    *     "refresh_token" : "42ecf7e848c392d89103c90a109d8b1f0fbdf6db16f528f4f",
    *     "token_type" : "bearer"
    *   }
  EOS
  config.default_locale = 'en'
  config.markup = Apipie::Markup::Markdown.new
  config.validate = false
end
