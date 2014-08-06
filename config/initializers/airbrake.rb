if Rails.env.production?
  Airbrake.configure do |config|
   config.api_key = '98f3dc707b372a825d449eda43ab09bc'
  end
end
