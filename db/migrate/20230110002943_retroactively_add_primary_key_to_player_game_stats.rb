class RetroactivelyAddPrimaryKeyToPlayerGameStats < ActiveRecord::Migration[7.0]
  def change
    add_column :nhl_player_game_stats, :id, :primary_key
    remove_index :nhl_player_game_stats, name: "index_nhl_player_game_stats_on_player_id"
    add_index :nhl_player_game_stats, :player_id
  end
end
