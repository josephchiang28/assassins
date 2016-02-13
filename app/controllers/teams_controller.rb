class TeamsController < ApplicationController
  def create
    if Team.where(game_id: params[:game_id], name: params[:team_name]).empty?
      @team = Team.create(game_id: params[:game_id], name: params[:team_name])
      flash[:notice] = 'Team "' + params[:team_name] + '" successfully created!'
      redirect_to show_game_path(name: params[:game_name])
    else
      flash[:notice] = 'Error: Team "' + params[:team_name] + '" already exists'
      redirect_to show_game_path(name: params[:game_name])
    end
  end
end