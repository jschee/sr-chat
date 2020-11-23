class MarketingsController < ApplicationController
  before_action :set_chat_room, only: [:chat]
  before_action :set_recipient, only: [:start_conversation, :create_chat]
  include CableReady::Broadcaster

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
    @chat_room = ChatRoom.find_by(id: params[:chat_id])
    @messages = @chat_room.messages
    @new_messages = @messages.take(@messages.count - 10)
    cable_ready["ChatChannel"].insert_adjacent_html(
      selector: "#messages-timeline-#{@chat_room.slug}=-",
      position: "afterbegin",
      html:     ApplicationController.render(
                  partial: "marketings/last_ten_messages",
                  locals: {messages: @new_messages.last(10)}
                )
    )
    cable_ready.broadcast
  end

  def send_attach
    @chat_room = ChatRoom.find_by(slug: params[:chat_slug])
    @user = User.find_by(id: params[:user_id])
    @message = Message.create(message_params)
    cable_ready["ChatChannel"].insert_adjacent_html(
      selector: "#messages-timeline-#{@chat_room.slug}-#{@user.slug}",
      position: "beforeend",
      html:     ApplicationController.render(
                  partial: "marketings/message",
                  locals: {msg: @message}
                )
    )
    cable_ready.broadcast
  end

  def delete_message
    @message = Message.find_by(slug: params[:message_slug])
    @message.destroy
    respond_to do |format|
      format.js
      format.html
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

  def remove_last_ten(all_messages)
    10.times.each do
      all_messages.pop # removes last 10 items
    end
    all_messages
  end

end

