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
        author.gitlab_name = u.username
        author.save
      end
    end
  end
end
