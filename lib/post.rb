require 'front_matter_parser'

class PostCollection
  def initialize(records)
    @records = records
  end

  def by_year
    @records.sort_by(&:date)
    .reverse
    .group_by(&:year).sort_by { |year, posts|
      year
    }.reverse
  end
end

class Post
  TOP_LEVEL_DIR = Dir.pwd
  BLOG_BASE_DIR = File.join(TOP_LEVEL_DIR, 'source', 'blog')
  POST_FILES = Dir["#{BLOG_BASE_DIR}/**/*.md"]

  attr_reader :file_path

  class << self
    def all
      POST_FILES.map { |x| new(x) }
    end

    def categories
      @_categories ||= by_category.keys
    end

    def by_category
      @_posts_by_category ||= begin
        _by_cat = Hash.new {|h,k| h[k] = Array.new }

        all.each do |post|
          post.categories.each do |category|
            _by_cat[category] << post
          end
        end
        _by_cat
      end
    end

    def by_year
      @_by_year ||= PostCollection.new(all).by_year
    end
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def link
    path = @file_path.match(/#{BLOG_BASE_DIR}\/(.*)\.md/)[1]
    "/blog/#{path}"
  end

  def title
    frontmatter['title']
  end

  def categories
    @categories ||= (frontmatter['categories'] || '').split(',').map(&:strip)
  end

  def year
    date.strftime("%Y")
  end

  def date
    date = frontmatter['date'] || DateFromGitLog.new(@file_path).to_date
    date.to_date
  end

  def exists?
    File.exists? @file_path
  end

  private

  def frontmatter
    @frontmatter ||= Parser.load(@file_path)
  end
end

class Parser
  def self.load(file)
    unsafe_loader = ->(string) { YAML.load(string) }
    FrontMatterParser::Parser.parse_file(
      file,
      loader: unsafe_loader
    ).front_matter
  rescue
    {}
  end
end

class DateFromGitLog
  def initialize(path)
    @path = path
  end

  def to_s
    @_date_from_git ||= `git log --follow --date=short --pretty=format:%ad --diff-filter=A -- #{@path}`
  end

  def to_date
    Date.parse(to_s)
  end
end
