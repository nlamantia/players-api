# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchPlayersJob, type: :job do
  describe '#perform' do
    subject { described_class.new }

    let(:baseball_player) { FactoryBot.build(:player, :baseball) }
    let(:basketball_player) { FactoryBot.build(:player, :basketball) }
    let(:football_player) { FactoryBot.build(:player, :football) }

    let(:http_status) { 200 }
    let(:football_response) { [JSON.parse(football_player.to_json).symbolize_keys] }
    let(:baseball_response) { [JSON.parse(baseball_player.to_json).symbolize_keys] }
    let(:basketball_response) { [JSON.parse(basketball_player.to_json).symbolize_keys] }

    before do
      allow(PlayersApi).to receive(:get_players_for_sport).with(:football).and_return(football_response)
      allow(PlayersApi).to receive(:get_players_for_sport).with(:baseball).and_return(baseball_response)
      allow(PlayersApi).to receive(:get_players_for_sport).with(:basketball).and_return(basketball_response)
    end

    context 'when no players already exist in the database' do
      it 'adds all players from all sports to the database', :aggregate_failures do
        expect do
          subject.perform
        end.to change(Player, :count).by(3)
        expect(Player.count).to eq(3)
      end
    end

    context 'when the baseball player is not already in the database' do
      let(:basketball_player) { FactoryBot.create(:player, :basketball) }
      let(:football_player) { FactoryBot.create(:player, :football) }

      it 'adds only the baseball player to the database', :aggregate_failures do
        expect do
          subject.perform
        end.to change(Player, :count).by(1)
        expect(Player.count).to eq(3)
      end
    end

    context 'when all players already exist in the database' do
      let(:baseball_player) { FactoryBot.create(:player, :baseball) }
      let(:basketball_player) { FactoryBot.create(:player, :basketball) }
      let(:football_player) { FactoryBot.create(:player, :football) }

      it 'does not add any players to the database', :aggregate_failures do
        expect do
          subject.perform
        end.not_to change(Player, :count)
        expect(Player.count).to eq(3)
      end
    end
  end
end
