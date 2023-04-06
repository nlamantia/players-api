# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    id { SecureRandom.random_number(1000000..9999999).to_s }
    firstname { 'Patrick' }
    lastname { 'Mahomes' }
    position { 'QB' }
    sport { :football }
    age { 26 }

    trait :baseball do
      firstname { 'Mike' }
      lastname { 'Trout' }
      sport { :baseball }
      position { 'CF' }
    end

    trait :basketball do
      firstname { 'LeBron' }
      lastname { 'James' }
      sport { :basketball }
      position { 'SF' }
    end

    trait :football do
      sport { :football }
      position { 'QB' }
    end
  end
end
