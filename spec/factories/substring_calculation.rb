FactoryBot.define do
  factory :substring_calculation do
    main_string { Faker::String.random(length: 6..18) }
    sub_string { Faker::String.random(length: 1..4) }
    association :user
  end
end
