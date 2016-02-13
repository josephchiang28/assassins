class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :team

  ROLE_GAMEMAKER = 'gamemaker'
  ROLE_PLAYER = 'player'
  ROLE_SPECTATOR = 'spectator'
end
