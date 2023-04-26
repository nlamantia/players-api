class PlayersController < ApplicationController
  before_action :scrub_age_param, only: %i[index]

  def index
    @players = Player.all

    sport = search_params[:sport]&.downcase&.to_sym
    if sport.present? && Player::SPORTS.include?(sport)
      @players = @players.send(sport)
    end

    param_scopes.each do |param, scope|
      @players = @players.send(scope, search_params[param]) unless search_params[param].nil?
    end

    @players = @players.page(params[:page] || 1)

    render json: { players: @players, current_page: @players.current_page, total_pages: @players.total_pages }
  end

  def show
    @player = Player.find(params[:id])
    render json: @player.as_json
  end

  private

  def search_params
    @search_params ||= params.permit(*permitted_search_params).to_h
  end

  def scrub_age_param
    return if search_params[:age].blank?

    # determine whether age param is a single number or a range
    if search_params[:age].include?('-')
      age_range = search_params[:age].split('-').map { |num| num.chomp.to_i }.sort
      search_params[:age] = age_range[0]..age_range[1]
    else
      search_params[:age] = search_params[:age].to_i
    end
  end

  def param_scopes
    @param_scopes ||= {
      position: :by_position,
      age: :aged,
      last_initial: :with_last_initial
    }
  end

  def permitted_search_params
    @permitted_search_params ||= %i[sport position age last_initial]
  end
end
