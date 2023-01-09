# frozen_string_literal: true

class NhlLiveGameStatProcessor
  def initialize(json, game_id)
    @json = json
    @game_id = game_id
  end

  def process
    @json["liveData"]["boxscore"]["teams"]["away"]["players"].each do |player_id, player|
      stats = player["stats"]["skaterStats"] || {}

      NhlPlayerGameStat.where(player_id:, nhl_game_id: @game_id).first_or_create.update!(
        assists: stats["assists"],
        goals: stats["goals"],
        hits: stats["hits"],
        points: nil,
        penalty_minutes: stats["penalty_minutes"]
      )
    end

    @json["liveData"]["boxscore"]["teams"]["home"]["players"].each do |player_id, player|
      stats = player["stats"]["skaterStats"] || {}

      NhlPlayerGameStat.where(player_id:, nhl_game_id: @game_id).first_or_create.update!(
        assists: stats["assists"],
        goals: stats["goals"],
        hits: stats["hits"],
        points: nil,
        penalty_minutes: stats["penalty_minutes"]
      )
    end

    @json["gameData"]["players"].each do |player_id, player|
      NhlPlayerGameStat.where(player_id:, nhl_game_id: @game_id).first_or_create.update!(
        player_name: player["fullName"],
        team_id: player["currentTeam"]["id"],
        team_name: player["currentTeam"]["name"],
        player_age: player["currentAge"],
        player_number: player["primaryNumber"],
        player_position: player["primaryPosition"]["name"]
      )
    end
  end
end