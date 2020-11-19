class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  before_create :generate_slug

  def generate_slug
    self.slug = SecureRandom.urlsafe_base64(6)
  end

end
