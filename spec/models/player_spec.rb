# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player) { FactoryBot.build(:player) }

  describe '#valid?' do
    context 'when all expected fields are present' do
      it 'is valid' do
        expect(player).to be_valid
      end
    end

    # since we are getting player IDs from the CBS API
    # we want to ensure an ID is specified
    describe '#id' do
      let(:player) { FactoryBot.build(:player, id: id) }
      let(:id) { nil }

      context 'when no id is specified' do
        it 'is not valid' do
          expect(player).not_to be_valid
        end
      end
    end
    
    describe '#sport' do
      let(:player) { FactoryBot.build(:player, sport: sport) }
      let(:sport) { nil }

      context 'when no sport is specified' do
        it 'is not valid' do
          expect(player).not_to be_valid
        end
      end

      context 'when sport is baseball' do
        let(:sport) { :baseball }

        it 'is valid' do
          expect(player).to be_valid
        end
      end

      context 'when sport is basketball' do
        let(:sport) { :basketball }

        it 'is valid' do
          expect(player).to be_valid
        end
      end

      context 'when sport is football' do
        let(:sport) { :football }

        it 'is valid' do
          expect(player).to be_valid
        end
      end
    end

    describe '#firstname' do
      let(:player) { FactoryBot.build(:player, firstname: first_name) }
      let(:first_name) { nil }

      context 'when first name is nil' do
        it 'is not valid' do
          expect(player).not_to be_valid
        end
      end
    end

    describe '#lastname' do
      let(:player) { FactoryBot.build(:player, lastname: last_name) }
      let(:last_name) { nil }

      context 'when last name is nil' do
        it 'is not valid' do
          expect(player).not_to be_valid
        end
      end
    end

    describe '#position' do
      let(:player) { FactoryBot.build(:player, position: position) }
      let(:position) { nil }

      context 'when position is nil' do
        it 'is not valid' do
          expect(player).not_to be_valid
        end
      end
    end

    describe '#age' do
      let(:player) { FactoryBot.build(:player, age: age) }

      context 'when age is not an integer' do
        let(:age) { '26.5' }

        it 'is not valid' do
          expect(player).not_to be_valid
        end
      end
    end
  end

  describe '#name_brief' do
    subject { player.name_brief }

    let(:player) { FactoryBot.build(:player, firstname: first_name, lastname: last_name, sport: sport) }
    let(:first_name) { 'Joe' }
    let(:last_name) { 'Schmo' }
    let(:sport) { :football }

    context 'when given a football player' do
      it 'returns first initial and last name' do
        expect(subject).to eq('J. Schmo')
      end
    end

    context 'when given a basketball player' do
      let(:sport) { :basketball }

      it 'returns first name and last initial' do
        expect(subject).to eq('Joe S.')
      end
    end

    context 'when given a baseball player' do
      let(:sport) { :baseball }

      it 'returns initials only' do
        expect(subject).to eq('J. S.')
      end
    end
  end
end
