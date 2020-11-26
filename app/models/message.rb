class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  before_create :generate_slug
  has_one_attached :file

  def generate_slug
    self.slug = SecureRandom.urlsafe_base64(6)
  end

  def readable_time
    if self.created_at <= 1.day.ago
      "Yesterday"
    elsif self.created_at <= 2.days.ago
      self.created_at.strftime('%m/%e/%y')
    else
      self.created_at.strftime('%l:%M %p')
    end
  end

end
