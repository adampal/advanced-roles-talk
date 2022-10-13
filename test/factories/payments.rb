FactoryBot.define do
  factory :payment do
    association :team
    name { "MyString" }
    amount { 1.5 }
  end
end
