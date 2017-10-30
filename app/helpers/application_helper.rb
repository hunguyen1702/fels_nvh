module ApplicationHelper
  def full_title page_title = ""
    default_title = t "title"
    return default_title if page_title.strip.empty?
    "#{page_title} | #{default_title}"
  end
end
