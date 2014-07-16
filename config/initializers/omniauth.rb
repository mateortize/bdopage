if Rails.env.development?
  provider :bonofa, bonofa_app_id, bonofa_app_secret, client_options: {
    site: "http://baio.sevendevs.de"
  }
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :bonofa, Rails.application.secrets[:bonofa]["app_id"], Rails.application.secrets[:bonofa]["secret_key"]
end
