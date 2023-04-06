# frozen_string_literal: true

class PlayersApi
  class PlayerFetchError < StandardError; end

  class << self
    def get_players_for_sport(sport)
      response = faraday_connection.get('/fantasy/players/list', query_params(sport))

      raise PlayerFetchError, response unless response.success?

      players = JSON.parse(response.body).dig('body', 'players')
      players.map(&:deep_symbolize_keys)
    end

    private

    CBS_API_BASE_URL = 'https://api.cbssports.com/'

    def query_params(sport)
      {
        sport: sport,
        version: '3.0',
        response_format: 'JSON'
      }.compact
    end

    def faraday_connection
      Faraday.new(url: CBS_API_BASE_URL) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
