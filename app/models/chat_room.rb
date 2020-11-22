class ChatRoom < ApplicationRecord
  has_many :chat_participants
  has_many :messages
  has_many :users, through: :chat_participants
  before_create :generate_slug

  def generate_slug
    self.slug = SecureRandom.urlsafe_base64(6)
  end

  def all_users_excluding(current_user)
    if self.users.count > 2
      self.users.select{|x| x != current_user}
    else
      self.users.select{|x| x != current_user}.first
    end
  end

end
