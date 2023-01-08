# frozen_string_literal: true

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

      if nhl_game && nhl_game.status == "Preview" && game["status"]["abstractGameState"] == "Live"
        Resque.enqueue(InjestGameDataJob, game["link"], nhl_game.id)
      end

      NhlGame.where(id: game["gamePk"]).first_or_create.update!(
        link: game["link"],
        status: game["status"]["abstractGameState"],
        home_team_name: game["teams"]["home"]["team"]["name"],
        home_team_id: game["teams"]["home"]["team"]["id"],
        away_team_name: game["teams"]["away"]["team"]["name"],
        away_team_id: game["teams"]["away"]["team"]["id"],
        game_date: game["gameDate"]
      )
    end
  rescue StandardError => e
    puts e.inspect
  end
end
