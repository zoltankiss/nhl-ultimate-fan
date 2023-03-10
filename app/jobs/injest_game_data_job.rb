# frozen_string_literal: true

require Rails.root.join('lib', 'nhl_live_game_stat_processor')

class InjestGameDataJob
  @queue = :high

  def self.perform(live_game_link, game_id, log_label = nil) # rubocop:disable Metrics/MethodLength
    Rails.logger.info "ran InjestGameDataJob with game_link: #{live_game_link}, game_id: #{game_id}"
    JobDatum.create!(
      job_name: "InjestGameDataJob",
      label: "#{log_label} game_link: #{live_game_link}, game_id: #{game_id}"
    )

    response = HTTParty.get(URI.join("https://statsapi.web.nhl.com", live_game_link))

    NhlLiveGameStatProcessor.new(response, game_id).process

    game_status = response["gameData"]["status"]["abstractGameState"]

    if game_status == "Live"
      sleep 300
      Resque.enqueue(InjestGameDataJob, live_game_link, game_id)
    end
  rescue StandardError => e
    Rails.logger.debug e.inspect
  end
end
