def gen_fun_fact(game)
  endpoint = "https://api.openai.com/v1/completions"
  api_key = ENV["OPENAI_API_KEY"]

  parameters = {
    "model": "text-davinci-003",
    "prompt": "Generate a fun fact about the #{game.game_title}",
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
    body: parameters.to_json
  )

  response["choices"].first["text"].strip
end

games = 0
NhlGame.get_nhl_games_without_a_fun_fact.each do |game|
  game.fun_facts.create(fun_fact: gen_fun_fact(game))
  games = games + 1
  break if games > 3
end
