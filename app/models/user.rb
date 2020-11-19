class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :chat_participants
  has_many :chat_rooms, through: :chat_participants
  before_create :generate_slug

  def generate_slug
    self.slug = SecureRandom.urlsafe_base64(6)
  end


end
