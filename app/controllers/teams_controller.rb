class TeamsController < ApplicationController

  # TODO: NEED TO ADD PERMISSION CHECKS
  def create
    if Team.where(game_id: params[:game_id], name: params[:team_name]).empty?
      @team = Team.create(game_id: params[:game_id], name: params[:team_name])
      flash[:notice] = 'Team "' + params[:team_name] + '" successfully created!'
    else
      flash[:notice] = 'Error: Team "' + params[:team_name] + '" already exists.'
    end
    redirect_to show_game_path(name: params[:game_name])
  end

  # TODO: NEED TO ADD PERMISSION CHECKS
  def delete
    if params[:team_id] == 0
      flash[:notice] = 'Cannot remove team "none".'
    else
      team_name = Team.find(params[:team_id]).name
      Player.where(game_id: params[:game_id], team_id: params[:team_id]).each do |p|
        p.update(team_id: 0)
      end
      Team.destroy(params[:team_id])
      flash[:notice] = 'Team "' + team_name + '" successfully deleted!'
    end
    redirect_to show_game_path(name: params[:game_name])
  end
end