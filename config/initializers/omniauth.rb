Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["ASSASSINXGAME_GOOGLE_CLIENT_ID"], ENV["ASSASSINXGAME_GOOGLE_CLIENT_SECRET"], scope: ['profile', 'email']
end