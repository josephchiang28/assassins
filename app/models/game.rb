class Game < ActiveRecord::Base
  has_many :players
  has_many :assignments
  has_many :teams

  STATUS_INACTIVE = 'inactive: assignments not generated game not started'
  STATUS_PENDING = 'pending: assignments generated game started'
  STATUS_ACTIVE = 'active'
  STATUS_SUSPENDED = 'suspended'
  STATUS_COMPLETED = 'completed'
  TeamCount = Struct.new(:name, :count)

  def create_ring(players = self.players.where(role: Player::ROLE_PLAYER))
    ring = players.shuffle
    # TODO: Improve ring generation algorith
    # ring = Array.new
    # team_players = Hash.new
    # players = players.sort_by{|p| p.team_id}
    # players.each do |p|
    #   if not team_players.has_key?(p.team.name)
    #     team_players[p.team.name] = Array.new
    #   end
    #   team_players[p.team.name].push(p)
    # end
    # player = players.delete_at(rand(players.length))
    # ring.push(player)
    # while not players.empty?
    #   # Randomly insert into ring
    # end
    return ring
  end

  def create_assignments_from_ring(ring, clean)
    self.assignments.where(time_terminated: nil).destroy_all
    for i in 0..ring.length-1
      player = ring[i]
      if clean
        player.points = 0
      end
      player.alive = true
      self.assignments.create(killer_id: player.id, target_id: ring[(i + 1) % ring.length].id, reverse_killed: false)
    end
  end

  def generate_clean_assignments
    self.assignments.destroy_all
    ring = self.create_ring
    self.create_assignments_from_ring(ring, true)
  end

end
