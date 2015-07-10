namespace :cover do
  desc "Rebuild cover for explore books."
  task :rebuild => :environment do
    Book.explored.each do |book|
      book.cover.recreate_versions!
    end
  end
end
