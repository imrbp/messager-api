FactoryBot.define do
    factory :conversation do
        transient do
            users { [] }
        end
        
        after(:create) do |conversation, evaluator|
            evaluator.users.each do |user|
                create(:conversation_participant, conversation: conversation, user: user)
                create(:conversation_message, conversation: conversation, user: user)
            end
        end
    end
end