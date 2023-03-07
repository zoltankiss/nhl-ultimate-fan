# frozen_string_literal: true

Resque.redis = if Rails.env == "developement"
                 'localhost:6379'
               else
                 ENV["REDISCLOUD_URL"]
               end
