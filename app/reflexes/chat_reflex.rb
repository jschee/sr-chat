class ChatReflex < ApplicationReflex
  include CableReady::Broadcaster
  def send_message(message)
    @msg = Message.create(  user_id: current_user.id,
                            chat_room_id: element.dataset.chat_room_id,
                            message: message
                          )

    cable_ready["DeliverMessageChannel"].insert_adjacent_html(
      selector: "#messages-timeline",
      position: "afterend",
      html:     ApplicationController.render(
                  partial: "marketings/message",
                  locals: {msg: @msg}
                )
    )
    cable_ready.broadcast

  end

end
