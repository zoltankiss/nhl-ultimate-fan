# frozen_string_literal: true

class NhlGamesController < ApplicationController
  def index
    render(
      json: {
        live_games: NhlGame.where(status: "Live"),
        other_games: NhlGame.where.not(status: "Live").order(created_at: :desc)
      }
    )
  end
end
