namespace :user do
  desc "Rebuild user."
  task :rebuild => :environment do
    User.all.each do |u|
      u.username = u.username.downcase
      u.email = "#{u.username}@zhibimo.com"
      u.save!

      if u.author
        author = u.author
        author.gitlab_id = u.gitlab_id
        author.gitlab_password = u.gitlab_password
        author.gitlab_username = u.username
        author.save
      end
    end
  end

  desc "Rebuild user for Gitlab."
  task :rebuild_gitlab => :environment do
    Author.all.each do |a|
      Gitlab.edit_user a.gitlab_id, username: a.gitlab_username, name: a.pen_name, email: a.user.eamil
    end
  end
end
