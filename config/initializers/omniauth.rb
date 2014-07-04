if Rails.env.development?
  Omniauth::Bonofa.configure do |config|
    config.site = "http://baio.sevendevs.de"
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :bonofa, Rails.application.secrets[:bonofa]["app_id"], Rails.application.secrets[:bonofa]["secret_key"]
end
