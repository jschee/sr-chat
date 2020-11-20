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
      @messages = @chat_room.messages
    end
  end

  private

  # def validate_users_share_a_chat_room
  #   current_user.chat_rooms.joins(:chat_participants).where(chat_participants: {user_id: @recipient.id}).first
  # end

  def set_recipient
    @recipient = User.find_by(slug: params[:user_slug])
  end

  def set_chat_room
    @chat_room = ChatRoom.find_by(slug: params[:chat_slug])
  end

end

