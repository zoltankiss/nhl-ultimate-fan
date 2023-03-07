# frozen_string_literal: true

puts ENV["REDISCLOUD_URL"].inspect

Resque.redis = if Rails.env == "developement"
                 'localhost:6379'
               else
                 ENV["REDISCLOUD_URL"]
               end
