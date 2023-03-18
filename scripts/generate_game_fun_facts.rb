# frozen_string_literal: true

games = 0
NhlGame.get_nhl_games_without_a_fun_fact.each do |game|
  game.save_fun_fact
  puts game.fun_facts.map(&:fun_fact).join(" ")
  puts game.fun_facts.map(&:prompt).join(" ")
  games += 1
  break if games > (EMV["TIMES"] || 3)
end
