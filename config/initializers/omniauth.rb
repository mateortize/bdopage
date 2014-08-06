Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
    provider :bonofa, Rails.application.secrets[:bonofa]["app_id"], Rails.application.secrets[:bonofa]["secret_key"], client_options: {
      site: "http://baio.sevendevs.de"
    }
  else
    provider :bonofa, Rails.application.secrets[:bonofa]["app_id"], Rails.application.secrets[:bonofa]["secret_key"]
  end
end
