class NhlGameProcessor
  def initialize(json)
    @json = json
  end

  def process
    games = @json["dates"][0]["games"]

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
  end
end