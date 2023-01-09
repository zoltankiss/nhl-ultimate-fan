# frozen_string_literal: true

class NhlGamesController < ApplicationController
  def index
    render(
      json: {
        live_games: NhlGame.live_games_with_game_stat_counts,
        other_games: NhlGame.not_live_games_with_game_stat_counts
      }
    )
  end
end
