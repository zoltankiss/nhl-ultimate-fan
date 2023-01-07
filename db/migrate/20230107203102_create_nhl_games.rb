class CreateNhlGames < ActiveRecord::Migration[7.0]
  def change
    create_table :nhl_games do |t|
      t.string :link
      t.string :status

      t.timestamps
    end
  end
end
