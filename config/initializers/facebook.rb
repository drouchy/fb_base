
yml_file = Rails.root.join('config', 'facebook.yml')
if File.exist? yml_file
  facebook_settings = YAML.load_file(yml_file)[Rails.env]
  FACEBOOK_APP_ID = facebook_settings['app_id']
  FACEBOOK_SECRET_KEY = facebook_settings['secret_key']
else
  FACEBOOK_APP_ID = ENV['FACEBOOK_APP_ID']
  FACEBOOK_SECRET_KEY = ENV['FACEBOOK_SECRET_KEY']
end
