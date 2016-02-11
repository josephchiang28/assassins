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
        @player = Player.create(user_id: current_user.id, game_id: @game.id, gamemaker: true, spectator: false, alive: true)
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
  end

  def join
    @game = Game.where(name: params[:name], passcode: params[:passcode]).first
    if @game.nil?
      flash[:notice] = 'Name or passcode incorrect, please try again.'
      redirect_to :back
    else
      players = Player.where(user_id: current_user.id, game_id: @game.id)
      if players.empty?
        @player = Player.create(user_id: current_user.id, game_id: @game.id, gamemaker: false, spectator: false, alive: true)
        flash[:notice] = 'You have successfully joined the game.'
      else
        @player = players.first
        flash[:notice] = 'You have already joined the game.'
      end
      # render 'show', name: @game.name
      redirect_to show_game_path(name: @game.name)
    end
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
  rescue ActionController::RedirectBackError
    return redirect_to root_path
  end
end