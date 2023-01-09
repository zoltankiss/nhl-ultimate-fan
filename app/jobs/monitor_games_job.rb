# frozen_string_literal: true

require Rails.root.join('lib', 'nhl_game_processor')

class MonitorGamesJob
  @queue = :high

  def self.perform
    puts "ran MonitorGamesJob"
    JobDatum.create!(job_name: "MonitorGamesJob", label: "")

    yesterdays_date_str = 1.day.ago.strftime("%Y-%m-%d")
    tommorrow_date_str = 1.day.from_now.strftime("%Y-%m-%d")
    response = HTTParty.get("https://statsapi.web.nhl.com/api/v1/schedule?&startDate=#{yesterdays_date_str}&endDate=#{tommorrow_date_str}")

    NhlGameProcessor.new(response).process
  rescue StandardError => e
    puts e.inspect
  end
end
