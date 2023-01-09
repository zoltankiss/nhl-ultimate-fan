# frozen_string_literal: true

class InjestGameDataJob
  @queue = :high

  def self.perform(live_game_link, game_id)
    puts "ran InjestGameDataJob with game_link: #{live_game_link}, game_id: #{game_id}"
    JobDatum.create!(job_name: "InjestGameDataJob", label: "game_link: #{live_game_link}, game_id: #{game_id}")

    response = HTTParty.get(URI.join("https://statsapi.web.nhl.com", live_game_link))

    response["liveData"]["boxscore"]["teams"]["away"]["players"].each do |player_id, player|
      stats = player["stats"]["skaterStats"] || {}

      NhlPlayerGameStat.where(player_id:, nhl_game_id: game_id).first_or_create.update!(
        assists: stats["assists"],
        goals: stats["goals"],
        hits: stats["hits"],
        points: nil,
        penalty_minutes: stats["penalty_minutes"]
      )
    end

    response["liveData"]["boxscore"]["teams"]["home"]["players"].each do |player_id, player|
      stats = player["stats"]["skaterStats"] || {}

      NhlPlayerGameStat.where(player_id:, nhl_game_id: game_id).first_or_create.update!(
        assists: stats["assists"],
        goals: stats["goals"],
        hits: stats["hits"],
        points: nil,
        penalty_minutes: stats["penalty_minutes"]
      )
    end

    response["gameData"]["players"].each do |player_id, player|
      NhlPlayerGameStat.where(player_id:, nhl_game_id: game_id).first_or_create.update!(
        player_name: player["fullName"],
        team_id: player["currentTeam"]["id"],
        team_name: player["currentTeam"]["name"],
        player_age: player["currentAge"],
        player_number: player["primaryNumber"],
        player_position: player["primaryPosition"]["name"]
      )
    end

    game_status = response["gameData"]["status"]["abstractGameState"]

    if game_status == "Live"
      sleep 300
      Resque.enqueue(InjestGameDataJob, live_game_link, game_id)
    end
  rescue StandardError => e
    puts e.inspect
  end
end
