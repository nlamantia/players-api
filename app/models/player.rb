class Player < ApplicationRecord
  SPORTS = [:baseball, :basketball, :football].freeze

  enum :sport, SPORTS.each_with_index.to_h

  validates :id, :firstname, :lastname, :position, :sport, presence: true
  validates :age, presence: true, numericality: { only_integer: true }
end
