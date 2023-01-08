task game_links: :environment do
  todays_date_str = DateTime.now.strftime("%Y-%m-%d")
  response = HTTParty.get("https://statsapi.web.nhl.com/api/v1/schedule?&startDate=#{todays_date_str}&endDate=#{todays_date_str}")

  games = JSON.parse(response.body)["dates"][0]["games"]
  
  games.each do |game|
    puts game["link"]
    puts game["status"]["abstractGameState"]
    puts "_" * 30
    puts ""
    puts ""
  end
end
