FactoryBot.define do
  factory :campaign do
    association :team
    name { "MyString" }
  end
end
