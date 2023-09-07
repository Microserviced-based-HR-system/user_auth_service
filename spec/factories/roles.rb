FactoryBot.define do
  factory :role do
    name { Faker::Job.position }
  end
end
