# frozen_string_literal: true

require "test_helper"

class FunFactTest < ActiveSupport::TestCase
  test "nhl_game is funfactable" do
    fun_fact = FactoryBot.create :fun_fact, fun_fact: "this is a fun fact"
    nhl_game = fun_fact.fun_factable

    assert_equal ["this is a fun fact"], nhl_game.fun_facts.map(&:fun_fact)
  end
end
