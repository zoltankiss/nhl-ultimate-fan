# frozen_string_literal: true

class NhlGame < ApplicationRecord
  def kick_off_game_data_injestion_job
    Resque.enqueue(InjestGameDataJob, link, id, "(`rails c` manually kick off)")
  end
end
