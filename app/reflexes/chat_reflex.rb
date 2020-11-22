class ChatReflex < ApplicationReflex
  delegate :current_user, to: :connection
  include CableReady::Broadcaster

  def send_message(message)
    @chat_room_slug = element.dataset.chat_room_slug
    @msg = Message.create(  user_id: current_user.id,
                            chat_room_id: element.dataset.chat_room_id,
                            message: message
                          )

    cable_ready["ChatChannel"].insert_adjacent_html(
      selector: "#messages-timeline-#{@chat_room_slug}",
      position: "beforeend",
      html:     ApplicationController.render(
                  partial: "marketings/message",
                  locals: {msg: @msg}
                )
    )
    cable_ready.broadcast
  end

  # def fetch_messages(last_messages_amount, chat_slug)
  #   morph :nothing
  #   @messages = ChatRoom.find_by(slug: chat_slug).messages
  #   p "1. --------------------------------#{@messages}"
  #   @last_messages_amount = last_messages_amount
  #   p "2. -------------------------------- #{@last_messages_amount}"
  #   @previous_messages_amount = 10
  #   p "3. -------------------------------- #{@previous_messages_amount}"
  #   @previous_messages_range = -(@last_messages_amount + @previous_messages_amount)..-(@last_messages_amount + 1)
  #   p "4. --------------------------------#{@previous_messages_range}"
  #   @previous_messages = @messages[@previous_messages_range]
  #   p "5. --------------------------------#{@previous_messages}"

  #   @previous_messages.each do |msg|
  #     cable_ready["ChatChannel"].insert_adjacent_html(
  #       selector: "#messages-timeline",
  #       position: "afterbegin",
  #       html:     ApplicationController.render(
  #                   partial: "marketings/message",
  #                   locals: {msg: msg}
  #                 )
  #     )
  #     cable_ready.broadcast
  #   end

  #   p "6. --------------------------------"
  # end

end
