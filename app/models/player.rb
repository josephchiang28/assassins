class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :team

  ROLE_GAMEMAKER = 'gamemaker'
  ROLE_ASSASSIN = 'assassin'
  ROLE_SPECTATOR = 'spectator'

  def is_gamemaker
    self.role == ROLE_GAMEMAKER
  end

  def is_assassin
    self.role == ROLE_ASSASSIN
  end

  def is_spectator
    self.role == ROLE_SPECTATOR
  end
end
