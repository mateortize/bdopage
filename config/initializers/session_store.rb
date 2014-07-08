# Be sure to restart your server when you modify this file.
if Rails.env.production?
  Rails.application.config.session_store :cookie_store, key: '_videopage7_session', domain: 'videopage7.com'
else
  Rails.application.config.session_store :cookie_store, key: '_videopage7_session'
end

