class ChatReflex < ApplicationReflex
  delegate :current_user, to: :connection
  include CableReady::Broadcaster

  def send_message(message, user_slug)
    morph :nothing
    @chat_room_slug = element.dataset.chat_room_slug
    @msg = Message.create(  user_id: current_user.id,
                            chat_room_id: element.dataset.chat_room_id,
                            message: message
                          )

    cable_ready["ChatChannel"].insert_adjacent_html(
      selector: ".chat-room-#{@chat_room_slug}",
      position: "beforeend",
      html:     ApplicationController.render(
                  partial: "marketings/message",
                  locals: {msg: @msg}
                )
    )
    cable_ready.broadcast
  end

  def fetch_messages(chat_room_id, user_slug, current_message_count)
    morph :nothing
    @chat_room = ChatRoom.find_by(id: chat_room_id)
    @messages = @chat_room.messages
    @new_messages = @messages.take(@messages.count - current_message_count)

    cable_ready["ChatChannel"].insert_adjacent_html(
      selector: "#messages-timeline-#{@chat_room.slug}-#{user_slug}",
      position: "afterbegin",
      html:     ApplicationController.render(
                  partial: "marketings/last_ten_messages",
                  locals: {messages: @new_messages.last(10)}
                )
    )
    cable_ready.broadcast
  end
end
