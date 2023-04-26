class Player < ApplicationRecord
  SPORTS = [:baseball, :basketball, :football].freeze

  enum :sport, SPORTS.each_with_index.to_h

  validates :id, :firstname, :lastname, :position, :sport, presence: true
  validates :age, presence: true, numericality: { only_integer: true }

  scope :with_last_initial, ->(last_initial) { where("lastname LIKE ?", "#{sanitize_sql_like(last_initial.upcase)}%") }
  scope :aged, ->(ages) { where(age: ages) }
  scope :by_position, ->(position) { where(position: position) }

  def average_position_age_diff
    # if a player object is constructed without saving to the database and
    # no players are in the database, the average age is this players age
    age - (self.class.send(sport.to_sym).where(position: position).average(:age)&.floor || age)
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

  def as_json(*args, **kwargs)
    json = super(except: %i[created_at updated_at sport], methods: %i[name_brief average_position_age_diff])
    json['first_name'] = json.delete('firstname')
    json['last_name'] = json.delete('lastname')
    json
  end

  private

  def first_initial
    firstname[0].upcase
  end

  def last_initial
    lastname[0].upcase
  end
end
