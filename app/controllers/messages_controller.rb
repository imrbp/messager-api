class MessagesController < ApplicationController
    before_action :set_conversation, only: [:index]
    before_action :validate_message, only: [:create]

    # GET /conversations/:conversation_id/messages
    def index
        if @conversation.present?
            @conversation.conversation_messages.last.is_read = true
            format_json = @conversation.conversation_messages.map do |message|
                {
                    id: message.id,
                    message: message.content,
                    sender: 
                    {
                        id: message.user.id,
                        name: message.user.name
                    },
                    sent_at: message.created_at
                }
            end
            json_response(format_json, :ok)
        else
            json_response({ error: 'Conversation not found' }, :not_found)
        end
    end

    # POST /conversations/:conversation_id/messages
    def create
        receiver = User.find_by(id: params[:user_id])

        conversation = current_user.conversations.
        includes(:conversation_participants).
        find_by(conversation_participants: {
            user_id: params[:user_id]
        })
        if !conversation.present?
            conversation = Conversation.create()
        end

        conversation.users << [current_user, receiver]

        message = ConversationMessage.create(
            content: @message,
            is_read: false,
            conversation: conversation,
            user: current_user
        )

        sender = current_user
        other_user = conversation.users.find { |user| user != sender }
        format_json ={
            id: conversation.id,
            message: message.content,
            sender:  {
                id: sender.id,
                name: sender.name
            },
            sent_at: message.created_at,
            conversation: {
                id: conversation.id,
                with_user: {
                    id: other_user.id,
                    name: other_user.name,
                },
            }
        }

        json_response(format_json, :created)
    end

    private
    def validate_message
        
        @message = params[:message]

        return if !@message.blank?
        json_response([], :unprocessable_entity)
    end


    def set_conversation
        @conversation = Conversation.find(params[:conversation_id])

        return if @conversation.users.include?(current_user)

        json_response({ message: 'You are not authorized to view this conversation' }, :forbidden)
    end
end
