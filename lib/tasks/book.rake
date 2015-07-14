namespace :book do
  desc "Rebuild book for Gitlab."
  task :rebuild_gitlab => :environment do
    Book.all.each do |b|
      b.slug = b.slug.downcase
      b.save!

      Gitlab.edit_project b.gitlab_id, name: b.title, path: b.slug
    end
  end
end
