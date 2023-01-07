class MonitorGamesJob
  @queue = :high

  def self.perform
    puts "ran MonitorGamesJob"
    JobDatum.create!(job_name: "MonitorGamesJob", label: "ran at")
    # todays_date_str = DateTime.now.strftime("%Y-%m-%d")
    # response = HTTParty.get("https://statsapi.web.nhl.com/api/v1/schedule?&startDate=#{todays_date_str}&endDate=#{todays_date_str}")
    
    # live_games = JSON.parse(response.body)['dates'][0]['games'].select { |game| game["status"]["abstractGameState"] == "Live" }

    # JSON.parse(response.body)['dates'][0]['games'].map { |game| game.keys }
    #   ["gamePk", "link", "gameType", "season", "gameDate", "status", "teams", "venue", "content"]
    # 

    # live_games.each do |live_game|
    #   InjestGameData.perform_now(live_game["link"])
    # end
  end
end