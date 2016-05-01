Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, Rails.application.secrets.twitter_api_key,
  #                   Rails.application.secrets.twitter_api_secret
  provider :twitter, ENV["TWITTER_CONSUMER_KEY"], ENV["TWITTER_SECRET_KEY"]
end
