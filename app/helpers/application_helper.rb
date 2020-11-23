module ApplicationHelper
  def readable_datetime(date)
    date.strftime('%b %e, %l:%M %p')
  end

  def readable_time(date)
    if date <= 1.day.ago
      "Yesterday"
    elsif date <= 2.days.ago
      date.strftime('%m/%e/%y')
    else
      date.strftime('%l:%M %p')
    end
  end

  def already_connected?(user)
    current_user.chat_rooms.map{|x| x.users.include?(user)}.any?
  end

  def raw(string)
    string.to_s.html_safe
  end

  def filename_truncate(file)
    if file.length > 15
      file[0..8] + '...' + file[file.length-6..-1]
    else
      file
    end
  end

end
