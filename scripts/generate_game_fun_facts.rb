# frozen_string_literal: true

games = 0
NhlGame.get_nhl_games_without_a_fun_fact.each do |game|
  game.fun_facts.create(fun_fact: game.gen_fun_fact)
  games += 1
  break if games > (EMV["TIMES"] || 3)
end
