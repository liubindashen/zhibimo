class Book < ActiveRecord::Base
  extend Enumerize
  mount_uploader :cover, CoverUploader

  acts_as_paranoid

  acts_as_taggable
  acts_as_taggable_on :skills, :interests

  before_validation :set_default
  validates :slug, presence: true, uniqueness: {scope: :author_id}, format: {with: /\A[a-z0-9][a-z0-9_\-]{1,512}\Z/i}
  validates :gitlab_id, presence: true, uniqueness: true, on: :update

  belongs_to :author
  has_many :builds, dependent: :destroy

  has_many :orders, dependent: :destroy
  has_many :complete_orders, -> { where aasm_state: :complete}, class_name: Order
  has_many :purchasers, through: :complete_orders, class_name: User, foreign_key: :user_id

  has_many :teams

  has_one :domain_binding,  :as => :domain_bindingtable, dependent: :destroy
  accepts_nested_attributes_for :domain_binding, update_only: true

  enumerize :profit, in: [:free, :purchase], default: :free, predicates: true

  validates_presence_of :profit, :title
  validates :donate, inclusion: {in: [true, false]}, if: 'free?'
  validates :price, numericality: { only_integer: true, greater_than: 0, less_than: 1000}, if: 'purchase?'

  delegate :pen_name, :username, :email, :to => :author, :prefix => true

  scope :explored, -> { where(explored: true) }

  def author_info
    "#{author_pen_name} <#{author_email}>"
  end

  def fetch_remote_repo(branch: 'master')
    FileUtils.cd git_path do
      if File.exists?("objects")
        system("git fetch #{git_origin_with_build} #{branch}:#{branch} --force")
      else
        system("git clone #{git_origin_with_build} . --bare")
      end
    end
  end

  def fetch_working_repo(branch: 'master')
    makedir

    FileUtils.cd working_path do
      unless File.exists?(".git")
        system("git clone #{git_origin_with_build} . --branch #{branch}")
        system("git config user.email #{author_email}")
        system("git config user.name #{author_username}")
      end
    end
  end

  def push_working_repo(branch: 'master')
    unless ENV['DISABLE_GITLIB']
      FileUtils.cd working_path do
        system("git push -f")
      end
    end
  end

  def entries
    fetch_working_repo

    Dir.chdir(working_path) do
      Dir.glob(File.join("**", "**", "*.md"))
    end.map do |path|
      Entry.new(self, path)
    end
  end

  def check_purchaser(user)
    return false unless user
    purchasers.where(id: user.id).exists?
  end

  def gitlab
    @gitlab_obj ||= Gitlab.project gitlab_id
  end

  def cover_url(default = nil)
    File.exists?("#{Dir.home}/books/#{author.username}/#{slug}/cover.jpg") ?
      "http://zhibimo.com/read/#{author.username}/#{slug}/cover.jpg" : default
  end

  def git_origin_with_build
    unless ENV['DISABLE_GITLIB']
      "git@git.zhibimo.com:#{namespace}.git"
    else
      "https://github.com/zhibimo/book-sample.git"
    end
  end

  def git_origin
    "http://git.zhibimo.com/#{namespace}.git"
  end

  after_create do
    makedir

    unless ENV['DISABLE_GITLIB']
      project = Gitlab.create_project slug, path: slug, user_id: author.gitlab_id, import_url: 'https://github.com/zhibimo/book-sample.git'
      update_attributes!(gitlab_id: project.id)

      hook_url = Rails.application.routes.url_helpers.hook_writer_book_builds_url(id, host: 'zhibimo.com')

      Gitlab.add_project_hook project.id, hook_url, \
        push_events: true, issues_events: true, \
        merge_requests_events: true, tag_push_events: true
    end
  end

  after_destroy do
    unless ENV['DISABLE_GITLIB']
      Gitlab.delete_project gitlab_id
    end
  end

  def self.from_hook(pl)
    user = User.find_by!(gitlab_id: pl['user_id'].to_i)
    user.books.find_by!(gitlab_id: pl['project_id'].to_i)
  end

  def namespace
    "#{author_username}/#{slug}"
  end

  def read_base_path
    "/read/#{namespace}/"
  end

  def desk_url
    "/books/#{id}/desk/"
  end

  def pdf_url
    "/read/#{namespace}/#{slug}.pdf"
  end

  def mobi_url
    "/read/#{namespace}/#{slug}.mobi"
  end

  def epub_url
    "/read/#{namespace}/#{slug}.epub"
  end

  GIT_NAME = 'scm'
  COMMITS_NAME = 'commits'
  RELEASE_NAME = 'release'
  WORKING_NAME = 'working'

  def path
    "#{Dir.home}/books/#{namespace}"
  end

  def git_path
    if self.other_git != nil 
      self.other_git
    else
      "#{path}/#{GIT_NAME}"
    end
  end

  def commits_path
    "#{path}/#{COMMITS_NAME}"
  end

  def release_path
    "#{path}/#{RELEASE_NAME}"
  end

  def working_path
    "#{path}/#{WORKING_NAME}"
  end

  def makedir
    FileUtils.mkdir_p path
    FileUtils.cd path do
      [GIT_NAME, COMMITS_NAME, RELEASE_NAME, WORKING_NAME].each do |name|
        FileUtils.mkdir_p name
      end
    end
  end

  alias_method :html_base_url, :read_base_path

  private

  def set_default
    if (!self.slug or self.slug.empty?) and self.title
      self.slug = Pinyin.t(self.title, splitter: '-')
    end

    self.slug.downcase!

    return
  end
end
