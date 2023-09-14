class ConversationsController < ApplicationController
    before_action :set_conversation, only: [:show]

    # GET /conversations
    def index
        conversations = current_user.conversations
        json_response(format_conversations(conversations))
    end

    # GET /conversations/:id
    def show
        if @conversation.present?
            json_response(format_conversation(@conversation))
        else
            json_response({ message: 'Conversation not found' }, :not_found)
        end
    end

    private
    def set_conversation
        @conversation = Conversation.find(params[:id])

        return if @conversation.users.include?(current_user)

        json_response({ message: 'You are not authorized to view this conversation' }, :forbidden)
    end

    def format_conversations(conversations)
        conversations.map do |conversation|
            format_conversation(conversation)
        end
    end

    def format_conversation(conversation)
        other_user = conversation.users.find { |user| user != current_user }
        unread_count = conversation.conversation_messages.where(is_read: false).count

        {
            id: conversation.id,
            with_user: format_user(other_user),
            last_message: format_last_message(conversation),
            unread_count: unread_count
        }
    end


    def format_user(user)
        {
            id: user.id,
            name: user.name,
            photo_url: user.photo_url
        }
    end

    def format_last_message(conversation)
        last_chat = conversation.conversation_messages.last

        if last_chat.present?
            {
                id: last_chat.id,
                sender: format_user(last_chat.user),
                sent_at: last_chat.created_at.to_s
            }
        else
            nil
        end
    end
end
