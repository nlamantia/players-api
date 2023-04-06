# frozen_string_literal: true

class FetchPlayersJob < ApplicationJob
  queue_as :default

  def perform
    Player::SPORTS.each do |sport|
      existing_player_ids = Player.send(sport).pluck(:id)
      PlayersApi.get_players_for_sport(sport).each do |p|
        next if existing_player_ids.include? p[:id]
        Player.create(**player_params(p), sport: sport)
      end
    end
  end

  private

  PLAYER_ATTRS = %i[id position age firstname lastname].freeze

  def player_params(player_hash)
    player_hash.select { |attr, _| PLAYER_ATTRS.include? attr  }
  end
end
