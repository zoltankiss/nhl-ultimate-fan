# frozen_string_literal: true

FactoryBot.define do
  factory :fun_fact do
    before(:create) do |fun_fact, _evaluator|
      nhl_game = create(:nhl_game)
      fun_fact.fun_factable = nhl_game
    end
  end
end
