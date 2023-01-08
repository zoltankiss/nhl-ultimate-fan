class NhlGame < ApplicationRecord
  def kick_off_game_data_injestion_job
    Resque.enqueue(InjestGameDataJob, link, id)
  end
end
