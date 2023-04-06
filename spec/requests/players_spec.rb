require 'rails_helper'

RSpec.describe "Players", type: :request do
  describe "GET /show" do
    let(:expected_response) do
      File.read(File.expand_path('../../fixtures/players_show.json', __FILE__))
    end
    let(:player_params) do
      JSON.parse(expected_response).except('name_brief', 'average_position_age_diff').tap do |hash|
        hash['firstname'] = hash.delete('first_name')
        hash['lastname'] = hash.delete('last_name')
      end
    end
    let!(:player) { FactoryBot.create(:player, **player_params) }

    it "returns http success" do
      get "/players/#{player.id}"
      expect(response).to have_http_status(:success)
    end

    it "returns the correct JSON" do
      get "/players/#{player.id}"
      expect(JSON.parse(response.body).keys).to contain_exactly(*JSON.parse(expected_response).keys)
    end

    context 'when given a player ID that does not exist' do
      it 'returns http not found' do
        get '/players/1'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

end
