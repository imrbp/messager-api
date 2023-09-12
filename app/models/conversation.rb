class Conversation < ApplicationRecord
    has_many :conversation_participants
    has_many :conversation_messages
    has_many :users, through: :conversation_participants
end
