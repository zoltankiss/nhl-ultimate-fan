# frozen_string_literal: true

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

      process_game(game)
    end
  end

  private

  def nhl_game(id)
    NhlGame.where(id:).first_or_create
  end

  def process_game(game) # rubocop:disable Metrics/AbcSize
    nhl_game(game["gamePk"]).tap { |game| save_fun_fact(game) }.update!(
      link: game["link"],
      status: game["status"]["abstractGameState"],
      home_team_name: game["teams"]["home"]["team"]["name"],
      home_team_id: game["teams"]["home"]["team"]["id"],
      away_team_name: game["teams"]["away"]["team"]["name"],
      away_team_id: game["teams"]["away"]["team"]["id"],
      game_date: game["gameDate"]
    )
  end

  def save_fun_fact(game)
    game.save_fun_fact if game.fun_facts.count.zero? && Rails.env != "test"
  end
end
