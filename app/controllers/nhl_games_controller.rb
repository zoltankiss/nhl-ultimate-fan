# frozen_string_literal: true

class NhlGamesController < ApplicationController
  def index
    render json: NhlGame.all
  end
end
