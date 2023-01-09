# frozen_string_literal: true

class NhlLiveGameStatProcessor
  def initialize(json, game_id)
    @json = json
    @game_id = game_id
  end

  def process
    process_live_data

    away_team_name = @json["gameData"]["teams"]["away"]["name"]
    home_team_name = @json["gameData"]["teams"]["home"]["name"]

    @json["gameData"]["players"].each do |player_id, player|
      opponent_team = opponent_team(away_team_name:, home_team_name:, player:)
      process_player_game_data(player_id:, player:, opponent_team:)
    end
  end

  private

  def process_live_data
    @json["liveData"]["boxscore"]["teams"]["away"]["players"].each do |player_id, player|
      process_player_live_data(player_id, player)
    end

    @json["liveData"]["boxscore"]["teams"]["home"]["players"].each do |player_id, player|
      process_player_live_data(player_id, player)
    end
  end

  def process_player_live_data(player_id, player)
    stats = player["stats"]["skaterStats"] || {}

    player_game_stat(player_id).update!(
      assists: stats["assists"],
      goals: stats["goals"],
      hits: stats["hits"],
      points: nil,
      penalty_minutes: stats["penalty_minutes"]
    )
  end

  def opponent_team(away_team_name:, home_team_name:, player:)
    return away_team_name if player["currentTeam"]["name"] == home_team_name
    return home_team_name if player["currentTeam"]["name"] == away_team_name
  end

  def process_player_game_data(player_id:, player:, opponent_team:)
    player_game_stat(player_id).update!(
      player_name: player["fullName"],
      team_id: player["currentTeam"]["id"],
      team_name: player["currentTeam"]["name"],
      player_age: player["currentAge"],
      player_number: player["primaryNumber"],
      player_position: player["primaryPosition"]["name"],
      opponent_team:
    )
  end

  def player_game_stat(player_id)
    NhlPlayerGameStat.where(player_id:, nhl_game_id: @game_id).first_or_create
  end
end
