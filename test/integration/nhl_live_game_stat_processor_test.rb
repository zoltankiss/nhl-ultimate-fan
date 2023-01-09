# frozen_string_literal: true

require "test_helper"
require Rails.root.join('lib', 'nhl_live_game_stat_processor')
require Rails.root.join('lib', 'nhl_game_processor')

class NhlLiveGameStatProcessorTest < ActionDispatch::IntegrationTest
  test "processing" do
    NhlPlayerGameStat.delete_all
    NhlGame.delete_all

    NhlGameProcessor.new(JSON.parse(File.read(Rails.root.join('test', 'json', 'schedule.json')))).process

    NhlLiveGameStatProcessor.new(
      JSON.parse(File.read(Rails.root.join('test', 'json', 'live_feed.json'))),
      2_022_020_639
    ).process

    assert_equal 8, NhlGame.count
    assert_equal 46, NhlPlayerGameStat.count

    player = NhlPlayerGameStat.where(player_id: "ID8471675").first

    assert_equal "ID8471675", player.player_id
    assert_equal 2_022_020_639, player.nhl_game_id
    assert_equal "Sidney Crosby", player.player_name
    assert_equal "5", player.team_id
    assert_equal "Pittsburgh Penguins", player.team_name
    assert_equal "35", player.player_age
    assert_equal "87", player.player_number
    assert_equal "Center", player.player_position
    assert_equal 2, player.assists
    assert_equal 0, player.goals
    assert_equal 0, player.hits
  end
end
