# frozen_string_literal: true

class NhlGame < ApplicationRecord
  has_many :nhl_player_game_stat
  has_many :fun_facts, as: :fun_factable

  attribute :nhl_player_game_stats_count
  attribute :fun_facts_count

  def game_title
    "#{away_team_name} vs #{home_team_name}"
  end

  def kick_off_game_data_injestion_job
    Resque.enqueue(InjestGameDataJob, link, id, "(`rails c` manually kick off)")
  end

  def gen_fun_fact
    endpoint = "https://api.openai.com/v1/completions"
    api_key = ENV["OPENAI_API_KEY"]

    parameters = {
      "model": "text-davinci-003",
      "prompt": "Generate a fun fact about the #{game_title}",
      "temperature": 0.7,
      "max_tokens": 256,
      "top_p": 1,
      "frequency_penalty": 0,
      "presence_penalty": 0
    }

    response = HTTParty.post(endpoint,
                             headers: {
                               "Authorization" => "Bearer #{api_key}",
                               "Content-Type" => "application/json"
                             },
                             body: parameters.to_json)

    response["choices"].first["text"].strip
  end

  def save_fun_fact
    fun_facts.create!(fun_fact: gen_fun_fact)
  end

  def self.save_fun_facts(n)
    NhlGame.get_nhl_games_without_a_fun_fact.limit(n).each(&:save_fun_fact)
  end

  def self.get_nhl_games_without_a_fun_fact
    NhlGame
      .joins("LEFT OUTER JOIN fun_facts ON fun_facts.fun_factable_id = nhl_games.id")
      .where("fun_facts.id IS NULL")
  end

  def self.get_nhl_games_with_a_fun_fact
    NhlGame
      .joins("LEFT OUTER JOIN fun_facts ON fun_facts.fun_factable_id = nhl_games.id")
      .where("fun_facts.id IS NOT NULL")
  end

  def self.live_games_with_game_stat_counts
    NhlGame
      .joins("LEFT OUTER JOIN nhl_player_game_stats ON nhl_player_game_stats.nhl_game_id = nhl_games.id")
      .joins("LEFT OUTER JOIN fun_facts ON fun_facts.fun_factable_id = nhl_games.id")
      .where(status: "Live")
      .order(created_at: :desc)
      .group("nhl_games.id, fun_facts.id")
      .select("count(fun_facts.id), count(nhl_player_game_stats.player_id) as nhl_player_game_stats_count, nhl_games.*, STRING_AGG(fun_facts.fun_fact, ',') as fun_facts")
  end

  def self.not_live_games_with_game_stat_counts
    NhlGame
      .joins("LEFT OUTER JOIN nhl_player_game_stats ON nhl_player_game_stats.nhl_game_id = nhl_games.id")
      .joins("LEFT OUTER JOIN fun_facts ON fun_facts.fun_factable_id = nhl_games.id")
      .where.not(status: "Live")
      .order(created_at: :desc)
      .group("nhl_games.id, fun_facts.id")
      .select("count(nhl_player_game_stats.player_id) as nhl_player_game_stats_count, nhl_games.*, STRING_AGG(fun_facts.fun_fact, ',') as fun_facts")
  end
end
