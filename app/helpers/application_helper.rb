module ApplicationHelper
  def avatar(user = current_user)
    if user.author && !user.author.avatar.blank?
      user.author.avatar
    else
      user.avatar
    end
  end
end
