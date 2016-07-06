CarrierWave.configure do |config|
  config.cache_dir = File.join(Rails.root, 'tmp', 'uploads')
  case Rails.env.to_sym
  when :test
    config.root = File.join(Rails.root, 'public')
  else
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
      region: 'eu-central-1'
    }
    config.fog_directory = Rails.application.secrets.aws_bucket
    config.fog_public = true
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.days.to_i}" }
  end
end
