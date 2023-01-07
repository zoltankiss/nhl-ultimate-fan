if Rails.env == "developement"
  Resque.redis = 'localhost:6379'
else
  Resque.redis = ENV["REDISCLOUD_URL"]
end