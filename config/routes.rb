# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :nhl_games, only: %i[index] do
    resources :nhl_player_game_stats, only: %i[index]
  end
end
