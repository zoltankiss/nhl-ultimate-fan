require "test_helper"
require Rails.root.join('lib', 'nhl_live_game_stat_processor')
require Rails.root.join('lib', 'nhl_game_processor')

class NhlLiveGameStatProcessorTest < ActionDispatch::IntegrationTest
  test "processing" do
    NhlPlayerGameStat.delete_all
    NhlGame.delete_all

    NhlGameProcessor.new(JSON.parse(File.read(Rails.root.join('test', 'json', 'schedule.json')))).process

    NhlLiveGameStatProcessor.new(JSON.parse(File.read(Rails.root.join('test', 'json', 'live_feed.json'))), 2022020639).process

    assert NhlGame.count > 0
  end
end
