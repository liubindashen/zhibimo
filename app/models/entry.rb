class Entry
  include ActiveModel::Validations

  attr_accessor :id, :path, :title, :content, :book

  validates_presence_of :book, :id, :path
  validate :check_path, if: 'new?'

  def initialize(book, path)
    self.book = book
    self.id = self.path = path
    self.title = parse_title
  end

  def read
    Dir.chdir(book.working_path) do
      self.content = File.read(path)
    end
  end

  def new?
    Dir.chdir(book.working_path) do
      !Pathname.new(path).exist?
    end
  end

  def necessary?
    path == 'README.md' or path == 'SUMMARY.md'
  end

  def touch!
    raise if (!new? or invalid?)

    Dir.chdir(book.working_path) do
      self.title = File.basename(path, ".md")
      content = "# #{self.title.upcase}"
      File.write(path, content)

      system("git add .")
      system("git commit --author=\"#{book.author_info}\" -m \"create #{name}\"")
    end
    
    self
  end

  def remove!
    raise if new? or necessary?

    Dir.chdir(book.working_path) do
      system("git rm -f #{path}")
      system("git add .")
      system("git commit --author=\"#{book.author_info}\" -m \"remove #{name}\"")
    end
  end

  def write!
    raise if new?

    Dir.chdir(book.working_path) do
      File.write(path, content)
      self.title = parse_title

      system("git add .")
      system("git commit --author=\"#{book.author_info}\" -m \"edit #{name}\"")
    end
  end


  def name
    path
  end

  private
  def check_path
    if path =~ /(\.{1,2}\/|^\/)/
      errors.add(:path, "INVALID PATH")
    end

    unless path =~ /\.md$/
      errors.add(:path, "NEED MARKDOWN FILE")
    end

    Dir.chdir(book.working_path) do
      if File.directory?(path)
        errors.add(:path, "PATH NEED FILE")
      end
    end
  end

  def parse_title
    begin 
      Dir.chdir(book.working_path) do
        first_line = File.open(path) do |f| 
          f.readline
        end
        match = /([#\s])*(?<title>[\S\s]+)/.match(first_line.chomp)
        match[:title]
      end
    rescue 
      nil 
    end
  end
end
