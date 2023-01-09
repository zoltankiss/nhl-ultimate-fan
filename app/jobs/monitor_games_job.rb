# frozen_string_literal: true

require Rails.root.join('lib', 'nhl_game_processor')

class MonitorGamesJob
  @queue = :high

  def self.perform
    puts "ran MonitorGamesJob"
    JobDatum.create!(job_name: "MonitorGamesJob", label: "")

    todays_date_str = DateTime.now.strftime("%Y-%m-%d")
    response = HTTParty.get("https://statsapi.web.nhl.com/api/v1/schedule?&startDate=#{todays_date_str}&endDate=#{todays_date_str}")

    NhlGameProcessor.new(response).process
  rescue StandardError => e
    puts e.inspect
  end
end
