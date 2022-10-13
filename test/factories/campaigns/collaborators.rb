FactoryBot.define do
  factory :campaigns_collaborator, class: 'Campaigns::Collaborator' do
    association :campaign
    user { nil }
    role_ids { "" }
  end
end
