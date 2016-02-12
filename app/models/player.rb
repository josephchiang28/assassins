class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  ROLE_GAMEMAKER = 'gamemaker'
  ROLE_PLAYER = 'player'
  ROLE_SPECTATOR = 'spectator'
end
