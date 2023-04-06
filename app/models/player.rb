class Player < ApplicationRecord
  enum :sport, { baseball: 0, basketball: 1, football: 2 }

  validates :id, :firstname, :lastname, :position, :sport, presence: true
  validates :age, presence: true, numericality: { only_integer: true }
end
