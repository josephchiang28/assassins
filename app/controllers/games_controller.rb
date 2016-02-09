class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create_or_join
    if not current_user
      flash[:notice] = "Please sign in to create or join a game"
      redirect_to :back
    end
    if params[:commit] == 'Create'
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
        flash[:notice] = "Game created!"
        redirect_to user_dashboard_path
      else
        flash[:notice] = "Name already exists, please enter another one."
        redirect_to :back
      end
    rescue
      flash[:notice] = "Ooops. Something went wrong. Game not created."
      redirect_to :back
    end
  end

  def join
    game = Game.where(name: params[:name], passcode: params[:passcode])
    if game.empty?
      flash[:notice] = "Name or passcode incorrect, please try again."
    else
      @player = Player.create(user_id: current_user.id, game_id: game.id, gamemaker: false, spectator: false, alive: true)
    end
    redirect_to :back
  end
end