class AddChatRoomSlugToChatParticipant < ActiveRecord::Migration[6.0]
  def change
    add_column :chat_participants, :chat_room_slug, :string
  end
end
