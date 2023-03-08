# frozen_string_literal: true

class NhlGame < ApplicationRecord
  has_many :nhl_player_game_stat
  has_many :fun_facts, as: :fun_factable

  attribute :nhl_player_game_stats_count

  def kick_off_game_data_injestion_job
    Resque.enqueue(InjestGameDataJob, link, id, "(`rails c` manually kick off)")
  end

  def self.live_games_with_game_stat_counts
    NhlGame
      .joins("LEFT OUTER JOIN nhl_player_game_stats ON nhl_player_game_stats.nhl_game_id = nhl_games.id")
      .where(status: "Live")
      .order(created_at: :desc)
      .group("nhl_games.id")
      .select("count(nhl_player_game_stats.player_id) as nhl_player_game_stats_count, nhl_games.*")
  end

  def self.not_live_games_with_game_stat_counts
    NhlGame
      .joins("LEFT OUTER JOIN nhl_player_game_stats ON nhl_player_game_stats.nhl_game_id = nhl_games.id")
      .where.not(status: "Live")
      .order(created_at: :desc)
      .group("nhl_games.id")
      .select("count(nhl_player_game_stats.player_id) as nhl_player_game_stats_count, nhl_games.*")
  end
end
