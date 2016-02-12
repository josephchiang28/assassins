class Game < ActiveRecord::Base
  has_many :players
  has_many :assignments
  has_many :teams

  STATUS_INACTIVE = 'inactive'
  STATUS_ACTIVE = 'active'
  STATUS_SUSPENDED = 'suspended'
  STATUS_COMPLETED = 'completed'

  def create_ring(players = self.players)
    ring = Array.new

    return ring
  end

  def generate_assignments
    self.assignments.destroy_all
    players = self.players
  end

end
