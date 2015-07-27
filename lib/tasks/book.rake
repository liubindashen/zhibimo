namespace :book do
  desc "Set book for free."
  task :profit_to_free => :environment do
    Book.all.each do |b|
      b.profit = :free
      b.donate = true
      b.save
    end
  end

  desc "Rebuild book for Gitlab."
  task :rebuild_gitlab => :environment do
    Book.all.each do |b|
      b.slug = b.slug.downcase
      b.save!

      Gitlab.edit_project b.gitlab_id, name: b.slug, path: b.slug
    end
  end

  desc "Rebuild book hook for Gitlab."
  task :rebuild_gitlab_hook => :environment do
    Book.all.each do |b|
      begin
        hooks = Gitlab.project_hooks b.gitlab_id
        hooks.each do |h| Gitlab.delete_project_hook b.gitlab_id, h.id end

        url = Rails.application.routes.url_helpers.hook_book_builds_url(b.id, host: 'zhibimo.com')

        Gitlab.add_project_hook b.gitlab_id, url, \
          push_events: true, issues_events: true, \
          merge_requests_events: true, tag_push_events: true

      rescue Gitlab::Error::NotFound
        puts "#{b.gitlab_id} #{b.title} not found"
      end
    end
  end
end
