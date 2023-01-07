class MonitorGamesJob
  @queue = :high

  def self.perform
    puts "ran MonitorGamesJob"
    JobDatum.create!(job_name: "MonitorGamesJob", label: "ran at")
    
    todays_date_str = DateTime.now.strftime("%Y-%m-%d")
    response = HTTParty.get("https://statsapi.web.nhl.com/api/v1/schedule?&startDate=#{todays_date_str}&endDate=#{todays_date_str}")

    games = JSON.parse(response.body)["dates"][0]["games"]

    # live_games = games.select { |game| game["status"]["abstractGameState"] == "Live" }

    # JSON.parse(response.body)['dates'][0]['games'].map { |game| game.keys }
    #   ["gamePk", "link", "gameType", "season", "gameDate", "status", "teams", "venue", "content"]
    

    games.each do |game|
      nhl_game = NhlGame.where(id: game["gamePk"]).first
      
      if nhl_game
        Resque.enqueue(InjestGameDataJob, live_game["link"]) if nhl_game.status == "Preview" && game["status"]["abstractGameState"] == "Live"
        nhl_game.update!(status: game["status"]["abstractGameState"])
      else
        NhlGame.create!(id: game["gamePk"], link: game["link"], status: game["status"]["abstractGameState"])
      end
    end
  rescue => e
    puts e.inspect
  end
end