class Book < ActiveRecord::Base
  extend Enumerize
  mount_uploader :cover, CoverUploader

  before_validation :set_default
  validates :slug, presence: true, uniqueness: {scope: :author_id}, format: {with: /\A[a-z0-9][a-z0-9_\-]{1,512}\Z/i}
  validates :gitlab_id, presence: true, uniqueness: true, on: :update

  belongs_to :author
  has_many :builds, dependent: :destroy
  has_many :entries, dependent: :destroy

  has_many :orders, dependent: :destroy
  has_many :purchasers, through: :orders, class_name: User, foreign_key: :user_id

  enumerize :profit, in: [:free, :purchase], default: :free, predicates: true

  validates_presence_of :profit
  validates :donate, inclusion: {in: [true, false]}, if: 'free?'
  validates :price, numericality: { only_integer: true, greater_than: 0, less_than: 1000}, if: 'purchase?'
  
  delegate :pen_name, :to => :author, :prefix => true

  scope :explored, -> { where(explored: true) }

  def check_purchaser(user)
    purchasers.where(id: user.id).exists?
  end

  def gitlab
    @gitlab_obj ||= Gitlab.project gitlab_id
  end

  def cover_url(default = nil)
    File.exists?("#{Dir.home}/books/#{author.username}/#{slug}/cover.jpg") ?
      "http://zhibimo.com/read/#{author.username}/#{slug}/cover.jpg" : default
  end

  def entry_create(path, content = "", message = nil)
    entry = entries.create(path: path)
    return nil unless entry.valid?
    #entry.repo_update(content, message || "[SYSTEM] ADD " + path)
    entry
  end

  def git_origin_with_build
    "git@git.zhibimo.com:#{namespace}.git"
  end

  def git_origin
    "http://git.zhibimo.com/#{namespace}.git"
  end

  after_create do
    unless ENV['DISABLE_GITLIB']
      project = Gitlab.create_project slug, path: slug, user_id: author.gitlab_id, import_url: 'https://github.com/zhibimo/book-sample.git'
      update_attributes!(gitlab_id: project.id)

      hook_url = Rails.application.routes.url_helpers.hook_book_builds_url(id, host: 'zhibimo.com')

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
    "#{author.username}/#{slug}"
  end

  def html_url
    "/read/#{namespace}/"
  end


  def summary_html
    render = SummaryRender.new base_url: html_url
    markdown = Redcarpet::Markdown.new(render)
    markdown.render(summary || "")
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

  private

  def set_default
    if (!self.slug or self.slug.empty?) and self.title
      self.slug = Pinyin.t(self.title, splitter: '-')
    end

    self.slug.downcase!

    return
  end
end
