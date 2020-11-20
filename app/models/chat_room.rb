class ChatRoom < ApplicationRecord
  has_many :chat_participants
  has_many :messages
  has_many :users, through: :chat_participants
  before_create :generate_slug

  def generate_slug
    self.slug = SecureRandom.urlsafe_base64(6)
  end

  def other_users_in_room(user)
    self.users.select{|x| x != user}.first # right now it just grabs first user
  end

end
