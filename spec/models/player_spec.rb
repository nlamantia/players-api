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

  describe '#with_last_initial' do
    subject { described_class.with_last_initial(last_initial) }

    let(:last_initial) { 'M' }
    let!(:player) { FactoryBot.create(:player) }

    it 'returns the correct player' do
      expect(subject).to contain_exactly(player)
    end

    context 'when the initial is lower case' do
      let(:last_initial) { 'm' }

      it 'returns the correct player' do
        expect(subject).to contain_exactly(player)
      end
    end

    context 'when the initial is numeric' do
      let(:last_initial) { '0' }

      it 'returns the correct player' do
        expect(subject).to be_empty
      end
    end
  end

  describe '#aged' do
    subject { described_class.aged(ages) }

    let!(:player) { FactoryBot.create(:player) }

    context 'when given a specific age' do
      let(:ages) { 26 }

      it 'returns the correct player' do
        expect(subject).to contain_exactly(player)
      end
    end

    context 'when given an age range' do
      let(:ages) { 20..30 }

      it 'returns the correct player' do
        expect(subject).to contain_exactly(player)
      end
    end
  end

  describe '#by_position' do
    subject { described_class.by_position(position) }

    let!(:player) { FactoryBot.create(:player) }
    let(:position) { 'QB' }

    it 'returns the correct player' do
      expect(subject).to contain_exactly(player)
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

  describe '#average_position_age_diff' do
    subject { player.average_position_age_diff }

    let(:player) { FactoryBot.create(:player, position: position, age: player_age) }
    let(:position) { 'QB' }
    let(:player_age) { 25 }
    let(:other_player_ages) { [29, 28, 26] }

    before do
      other_player_ages.each { |age| FactoryBot.create(:player, position: position, age: age)}
    end

    context 'when the player is younger than the average age for their position' do
      it 'returns the correct negative number' do
        expect(subject).to eq(-2)
      end
    end

    context 'when the player is older than the average age for their position' do
      let(:player_age) { 35 }

      it 'returns the correct positive number' do
        expect(subject).to eq(6)
      end
    end

    context 'when the player is exactly the average age for their position' do
      let(:other_player_ages) { [25, 25] }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when the player is the only player at their position in the database' do
      let(:other_player_ages) { [] }

      before do
        FactoryBot.create(:player, position: 'RB', age: 28)
      end

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end
  end

  describe '#as_json' do
    subject { player.as_json }

    let(:player) { FactoryBot.create(:player) }

    it 'contains the id property' do
      expect(subject['id']).not_to be_blank
    end

    it 'contains the firstname property' do
      expect(subject['first_name']).not_to be_blank
    end

    it 'contains the lastname property' do
      expect(subject['last_name']).not_to be_blank
    end

    it 'contains the position property' do
      expect(subject['position']).not_to be_blank
    end

    it 'contains the age property' do
      expect(subject['age']).not_to be_blank
    end

    it 'contains the name_brief property' do
      expect(subject['name_brief']).not_to be_blank
    end

    it 'contains the average_position_age_diff property' do
      expect(subject['average_position_age_diff']).not_to be_blank
    end

    it 'does not contain the sport property' do
      expect(subject['sport']).to be_blank
    end

    it 'does not contain the updated_at property' do
      expect(subject['updated_at']).to be_blank
    end

    it 'does not contain the created_at property' do
      expect(subject['created_at']).to be_blank
    end
  end
end
