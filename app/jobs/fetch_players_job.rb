# frozen_string_literal: true

class FetchPlayersJob < ApplicationJob
  queue_as :default

  def perform
    Player::SPORTS.each do |sport|
      PlayersApi.get_players_for_sport(sport).each do |p|
        player = Player.where(id: p[:id]).first
        next Player.create(**player_params(p), sport: sport) if player.nil?
        player.update(**player_params(p), sport: sport)
      end
    end
  end

  private

  PLAYER_ATTRS = %i[id position age firstname lastname].freeze

  def player_params(player_hash)
    player_hash.select { |attr, _| PLAYER_ATTRS.include? attr  }
  end
end
