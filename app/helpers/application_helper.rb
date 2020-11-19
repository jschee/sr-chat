module ApplicationHelper

  def readable_datetime(date)
    date.strftime('%b %e, %l:%M %p')
  end

  def already_connected?(user)
    current_user.chat_rooms.map{|x| x.users.include?(user)}.any?
  end

end
