class User < ApplicationRecord
  # encrypt password
  has_secure_password

  has_many :conversation_participants
  has_many :conversation_messages
  has_many :conversations, through: :conversation_participants
  
end
