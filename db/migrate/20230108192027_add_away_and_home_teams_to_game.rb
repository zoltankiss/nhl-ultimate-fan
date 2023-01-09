# frozen_string_literal: true

class AddAwayAndHomeTeamsToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :nhl_games, :away_team_name, :string
    add_column :nhl_games, :home_team_name, :string

    add_column :nhl_games, :away_team_id, :integer
    add_column :nhl_games, :home_team_id, :integer

    add_column :nhl_games, :game_date, :string
  end
end
