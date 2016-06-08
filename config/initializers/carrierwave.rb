CarrierWave.configure do |config|
  config.cache_dir = File.join(Rails.root, 'tmp', 'uploads')
  case Rails.env.to_sym
    when :development
      config.root = File.join(Rails.root, 'public')
    when :production
      config.fog_provider = 'fog/aws'
      config.fog_credentials = {
          provider: 'AWS',
          aws_access_key_id: 'xxx',
          aws_secret_access_key: 'yyy',
          # region:                'eu-west-1',
          # host:                  's3.example.com',
          # endpoint:              'https://s3.example.com:8080'
      }
      config.fog_directory = 'name_of_directory'
      config.fog_public = true
      config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }
  end
end
