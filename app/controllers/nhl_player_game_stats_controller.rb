# frozen_string_literal: true

class NhlPlayerGameStatsController < ApplicationController
  def index
    render json: NhlPlayerGameStat.where(nhl_game_id: params[:nhl_game_id]).all
  end
end
