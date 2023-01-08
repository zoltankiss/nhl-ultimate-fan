class CreateNhlPlayerGameStats < ActiveRecord::Migration[7.0]
  def change
    create_table :nhl_player_game_stats, id: false do |t|
      t.string :player_id
      t.references :nhl_game
      t.string :player_name
      t.string :team_id
      t.string :team_name
      t.string :player_age
      t.string :player_number
      t.string :player_position
      t.integer :assists
      t.integer :goals
      t.integer :hits
      t.integer :points
      t.integer :penalty_minutes
      t.string :opponent_team

      t.index :player_id, unique: true

      t.timestamps
    end
  end
end
