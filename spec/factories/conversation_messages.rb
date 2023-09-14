FactoryBot.define do
    factory :conversation_message do
        association :user
        association :conversation
        content { Faker::Lorem.sentence }
    end
end