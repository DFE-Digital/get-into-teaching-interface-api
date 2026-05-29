Devise.setup do |config|
  config.secret_key = Rails.application.secret_key_base if Rails.env.test?
end
