class PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
    render json: @player.as_json
  end
end
