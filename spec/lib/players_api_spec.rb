# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayersApi do
  describe '.get_players_for_sport' do
    subject(:players) { described_class.get_players_for_sport(sport) }

    let(:sport) { :football }
    let(:cbs_url) { 'https://api.cbssports.com/fantasy/players/list?version=3.0&sport=football&response_format=JSON' }
    let(:http_status) { 200 }
    let(:http_response_body) do
      {
        status: http_status,
        body: {
          players: player_hash_array
        }
      }.to_json
    end
    let(:player_hash_array) { [JSON.parse(FactoryBot.build(:player, sport: sport).to_json).symbolize_keys] }

    before do
      stub_request(:get, cbs_url).to_return(status: http_status, body: http_response_body)
    end

    context 'when the request to CBS API is successful' do
      it 'returns an array of players as hashes' do
        expect(players).to eq(player_hash_array)
      end
    end

    context 'when the request to CBS API fails' do
      let(:http_status) { 503 }
      let(:http_response_body) { { message: 'Failure to retrieve players' }.to_json }

      it 'raises an error' do
        expect do
          players
        end.to raise_error(PlayersApi::PlayerFetchError)
      end
    end
  end
end
