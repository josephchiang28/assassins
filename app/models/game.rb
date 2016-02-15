class Game < ActiveRecord::Base
  has_many :players
  has_many :assignments
  has_many :teams

  STATUS_INACTIVE = 'inactive: assignments not generated game not started'
  STATUS_PENDING = 'pending: assignments generated game started'
  STATUS_ACTIVE = 'active'
  STATUS_SUSPENDED = 'suspended'
  STATUS_COMPLETED = 'completed'
  FORWARD_KILL_POINTS = 1
  REVERSE_KILL_POINTS = 2
  TeamCount = Struct.new(:name, :count)

  def create_ring(players = self.players.where(role: Player::ROLE_ASSASSIN))
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
        player.update(points: 0)
        player.update(kill_code: SecureRandom.base64(5))
      end
      player.update(alive: true)
      target_id = ring[(i + 1) % ring.length].id
      player.update(target_id: target_id)
      self.assignments.create(killer_id: player.id, target_id: target_id, status: Assignment::STATUS_INACTIVE)
    end
  end

  def generate_clean_assignments
    self.assignments.destroy_all
    ring = self.create_ring
    self.create_assignments_from_ring(ring, true)
  end

  def activate
    self.assignments.each do |assignment|
      assignment.update(status: Assignment::STATUS_ACTIVE)
      assignment.update(time_activated: Time.now)
    end
    self.update(status: Game::STATUS_ACTIVE)
  end

  def confirm_kill(player, kill_code, reverse=false)
    if reverse
      victim = Player.find(player.assassin_id)
    else
      victim = Player.find(player.target_id)
    end
    if kill_code == victim.kill_code
      return true
    end
    return false
  end

  def register_kill(player, kill_code, reverse=false)
    if not confirm_kill(player, kill_code, reverse)
      return false
    end
    if reverse
      victim = Player.find(player.assassin_id)
      new_assassin = Player.find(victim.assassin_id)
      new_assassin.update(target_id: player.id)
      player.update(assassin_id: new_assassin.id)
      player.increment!(:points, by = REVERSE_KILL_POINTS)
      assignment_reversed = self.assignments.where(killer_id: victim.id, target_id: player.id, status: Assignment::STATUS_ACTIVE).first
      assignment_reversed.update(status: Assignment::STATUS_BACKFIRED, time_deactivated: Time.now)
      assignment_stolen = self.assignments.where(killer_id: new_assassin.id, target_id: victim.id, status: Assignment::STATUS_ACTIVE).first
      assignment_stolen.update(status: Assignment::STATUS_STOLEN, time_deactivated: Time.now)
      self.assignments.create(killer_id: new_assassin.id, target_id: player.id, status: Assignment::STATUS_ACTIVE, time_activated: Time.now)
    else
      victim = Player.find(player.target_id)
      next_target = Player.find(victim.target_id)
      next_target.update(assassin_id: player.id)
      player.update(target_id: victim.target_id)
      player.increment!(:points, by = FORWARD_KILL_POINTS)
      assignment_curr = self.assignments.where(killer_id: player.id, target_id: victim.id, status: Assignment::STATUS_ACTIVE).first
      assignment_curr.update(status: Assignment::STATUS_COMPLETED, time_deactivated: Time.now)
      assignment_failed = self.assignments.where(killder_id: victim.id, target_id: next_target.id, status: Assignment::STATUS_ACTIVE).first
      assignment_failed.update(status: Assignment::STATUS_FAILED, time_deactivated: Time.now)
      self.assignments.create(killer_id: player.id, target_id: next_target.id, status: Assignment::STATUS_ACTIVE, time_activated: Time.now)
    end
    return true
  end

end
