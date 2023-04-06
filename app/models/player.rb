class Player < ApplicationRecord
  SPORTS = [:baseball, :basketball, :football].freeze

  enum :sport, SPORTS.each_with_index.to_h

  validates :id, :firstname, :lastname, :position, :sport, presence: true
  validates :age, presence: true, numericality: { only_integer: true }

  def average_position_age_diff
    age - (self.class.where(position: position).average(:age))
  end

  def name_brief
    case sport
    when 'football'
      "#{first_initial}. #{lastname}"
    when 'basketball'
      "#{firstname} #{last_initial}."
    when 'baseball'
      "#{first_initial}. #{last_initial}."
    end
  end

  private

  def first_initial
    firstname[0].upcase
  end

  def last_initial
    lastname[0].upcase
  end
end
