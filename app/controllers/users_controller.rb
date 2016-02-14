class UsersController < ApplicationController
  def dashboard
    @game_players = current_user.players
    @gamemakers, @players, @spectators = [], [], []
    @gamemaker_games, @player_games, @spectator_games = [], [], []
    @game_players.each do |p|
      if p.role == Player::ROLE_GAMEMAKER
        @gamemakers.push(p)
        @gamemaker_games.push(p.game)
      elsif p.role == Player::ROLE_ASSASSIN
        @players.push(p)
        @player_games.push(p.game)
      else
        @spectators.push(p)
        @spectator_games.push(p.game)
      end
    end
  end
end