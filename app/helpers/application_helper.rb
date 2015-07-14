module ApplicationHelper
  def avatar
    if current_author && !current_author.avatar.blank?
      current_author.avatar
    else
      current_user.avatar
    end
  end
end
