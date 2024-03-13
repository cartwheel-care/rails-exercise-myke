FactoryBot.define do
  factory :contact do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    patient { nil }

    trait :with_patient do
      patient { association :patient, first_name: first_name, last_name: last_name }
    end
  end
end
