class InjestGameDataJob
  @queue = :high

  def self.perform(live_game_link)
    puts "ran InjestGameDataJob with game link: #{live_game_link}"
  end
end