class Api::TeamsController < ApplicationController

  before_action :require_login

  def index
    @teams = current_user.teams
    render 'api/teams/index'
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      emails = params[:team][:emails]
      TeamMembership.create(team_id: @team.id, member_id: current_user.id)
      @users = create_teammemberships(@team, emails)

      render 'api/teams/show_team_and_members'
    else
      render json: @team.errors.full_messages, status: 422
    end
  end

  def show
    @team = current_user.teams.find(params[:id])
    render 'api/teams/show_members'
  end

  def update
    @team = current_user.teams.find(params[:id])
    emails = params[:team][:emails]
    if emails
      @users = create_teammemberships(@team, emails);
      render 'api/teams/show_team_and_members'
    else
      if @team.update(team_params)
        render 'api/teams/show_team'
      else
        render json: @team.errors.full_messages, status: 422
      end
    end
  end

  # remove a user from a team
  def destroy
    team_id = params[:id]
    user = current_user
    TeamMembership.find_by(
      team_id: team_id,
      member_id: user.id
    ).destroy
    render json: {userId: user.id}
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def create_teammemberships(team, emails)
    # will return invalid_emails in future
    invalid_emails = []
    users = []
    emails = emails.delete(' ').split(',')

    emails.each do |email|
      user = User.find_by(username: email)
      invalid_emails << email unless user
      TeamMembership.create(team_id: team.id, member_id: user.id)
      users << user
    end

    return users << current_user
  end

end
