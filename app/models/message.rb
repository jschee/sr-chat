class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  before_create :generate_slug
  has_one_attached :file

  def generate_slug
    self.slug = SecureRandom.urlsafe_base64(6)
  end

end
