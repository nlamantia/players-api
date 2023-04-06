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

  describe 'GET /players/index' do
    let!(:player) { FactoryBot.create(:player) }

    let(:query_params) do
      {
        sport: sport,
        age: age,
        position: position,
        last_initial: last_initial
      }
    end
    let(:sport) { 'football' }
    let(:age) { '25 - 27' }
    let(:position) { 'QB' }
    let(:last_initial) { 'M' }

    it 'returns http success' do
      get '/players', params: query_params
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct players' do
      get '/players', params: query_params
      expect(response.body).to eq([player.as_json].to_json)
    end

    context 'when the age is a specific age' do
      let(:age) { 26 }

      it 'returns http success' do
        get '/players', params: query_params
        expect(response).to have_http_status(:success)
      end

      it 'returns the correct players' do
        get '/players', params: query_params
        expect(response.body).to eq([player.as_json].to_json)
      end
    end

    context 'when the search matches no players' do
      let(:position) { 'ZZ' }

      it 'returns http success' do
        get '/players', params: query_params
        expect(response).to have_http_status(:success)
      end

      it 'returns the no players' do
        get '/players', params: query_params
        expect(response.body).to eq([].to_json)
      end
    end
  end
end
