class NhlPlayerGameStat < ApplicationRecord
  self.primary_key = :player_id
  
  belongs_to :nhl_game
end