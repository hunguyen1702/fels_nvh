module ApplicationHelper
  def full_title page_title = ""
    default_title = t "title"
    return default_title if page_title.strip.empty?
    "#{page_title} | #{default_title}"
  end

  def activity_icon activity
    if activity.following? || activity.unfollow?
      Settings.activity.follow_icon
    elsif activity.create_lesson?
      Settings.activity.create_lesson
    elsif activity.finish_lesson?
      Settings.activity.finish_lesson
    end
  end
end
