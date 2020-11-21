class MarketingsController < ApplicationController
  before_action :set_chat_room, only: [:chat]
  before_action :set_recipient, only: [:start_conversation, :create_chat]

  def home
    @users = User.where.not(id: current_user.id).order(created_at: :asc)
    if current_user.chat_rooms.any?
      @chat_room = ChatRoom.find(current_user.chat_rooms.joins(:chat_participants).where(chat_participants: {chat_room_id: 1}).pluck(:id).first)
    end
  end

  def start_conversation
    @recipient = User.find_by(slug: params[:user_slug])
  end

  def create_chat
    chat_room = ChatRoom.create
    ChatParticipant.create(chat_room_id: chat_room.id, chat_room_slug: chat_room.slug, user_id: current_user.id)
    ChatParticipant.create(chat_room_id: chat_room.id, chat_room_slug: chat_room.slug, user_id: @recipient.id)
    if chat_room.save
      redirect_to chat_path(chat_slug: chat_room.slug)
    end
  end

  def chat
    if @chat_room
      @chat_rooms = current_user.chat_rooms
      recipient = @chat_room.users.select{|x| x.id != current_user.id}
      @recipient = recipient.first
      @messages = @chat_room.messages.last(10)
    end
  end

  def get_old_messages
    # @last_messages_amount = params[:message_count].to_i
    # @previous_messages_amount = 10
    # @previous_messages_range = -(@last_messages_amount + @previous_messages_amount)..-(@last_messages_amount + 1)
    # @previous_messages = @messages[@previous_messages_range]
    # @previous_messages



    @chat_messages = ChatRoom.find_by(slug: params[:chat_slug]).messages
    @messages = @chat_messages[0..-11]
    @messages_enum = @messages.lazy.reverse_each.each_slice(10).map(&:reverse)
    @messages_enum.next # Fetch the last 10 messages
    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: "messages", formats: [:html]) }
      }
    end
  end

  def send_attach
    @chat_room = ChatRoom.find_by(slug: params[:chat_slug])
    @user = User.find_by(id: params[:user_id])
    @message = Message.create(message_params)
    respond_to do |format|
      format.js
      format.html do
        redirect_to request.referrer
      end
    end
  end

  private

  def set_recipient
    @recipient = User.find_by(slug: params[:user_slug])
  end

  def set_chat_room
    @chat_room = ChatRoom.find_by(slug: params[:chat_slug])
  end

  def message_params
    params.require(:message).permit(:message, :user_id, :chat_room_id, :file)
  end

end

