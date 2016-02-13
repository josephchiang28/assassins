class GamesController < ApplicationController

  def new
    @game = Game.new
  end

  def create_or_join
    if current_user.nil?
      flash[:notice] = 'Please sign in to create or join a game'
      redirect_to :back
    elsif params[:commit] == 'Create'
      create
    elsif params[:commit] == 'Join'
      join
    else
      # SHOULD NEVER REACH HERE
    end
  end

  def create
    begin
      # Need to change this
      if Game.where(name: params[:name]).empty?
        @game = Game.create(name: params[:name], passcode: params[:passcode])
        @player = Player.create(user_id: current_user.id, game_id: @game.id, nickname: params[:nickname], role: Player::ROLE_GAMEMAKER, alive: true)
        flash[:notice] = 'Game created!'
        redirect_to show_game_path(name: @game.name)
      else
        flash[:notice] = 'Name already exists, please enter another one.'
        redirect_to :back
      end
    rescue
      flash[:notice] = 'Ooops. Something went wrong. Game not created.'
      redirect_to :back
    end
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def join
    @game = Game.where(name: params[:name], passcode: params[:passcode]).first
    if @game.nil?
      flash[:notice] = 'Name or passcode incorrect, please try again.'
      redirect_to :back
    else
      @player = Player.where(user_id: current_user.id, game_id: @game.id).first
      if @player.nil?
        @player = Player.create(user_id: current_user.id, game_id: @game.id, nickname: params[:nickname], role: Player::ROLE_PLAYER, alive: true)
        flash[:notice] = 'You have successfully joined the game.'
      else
        flash[:notice] = 'You have already joined the game.'
      end
      # render 'show', name: @game.name
      redirect_to show_game_path(name: @game.name)
    end
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def show
    # Entering each if is an error, else is not
    has_permission = true
    if current_user.nil?
      has_permission = false
    else
      @game ||= Game.where(name: params[:name]).first
      if @game.nil?
        has_permission = false
      else
        @player ||= Player.where(user_id: current_user.id, game_id: @game.id).first
        if @player.nil?
          has_permission = false
        end
      end
    end
    if not has_permission
      flash[:notice] = 'Error: You do not have permission to view the game named ' + params[:name] + '.'
      return redirect_to :back
    end
    @teams = @game.teams
    @team_id_pairs = Array.new
    @team_id_pairs.push(['none', 0])
    @teams.each do |t|
      @team_id_pairs.push([t.name, t.id])
    end
    @gamemakers, @players, @spectators = [], [], []
    @participants = @game.players
    @participants.each do |p|
      if p.role == Player::ROLE_GAMEMAKER
        @gamemakers.push(p)
      elsif p.role == Player::ROLE_PLAYER
        @players.push(p)
      else
        @spectators.push(p)
      end
    end
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def join_team
    redirect_to show_game_path
  end

  def generate_assignments
    has_permission = true
    if current_user.nil?
      has_permission = false
    else
      @game ||= Game.where(name: params[:name]).first
      if @game.nil?
        has_permission = false
      else
        @player ||= Player.where(user_id: current_user.id, game_id: @game.id).first
        if @player.nil?
          has_permission = false
        end
      end
    end
    if not has_permission
      flash[:notice] = 'Error: You do not have permission to view the game named ' + params[:name] + '.'
      return redirect_to :back
    end
    @game.generate_assignments
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
end