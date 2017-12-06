require_relative './lib/category'
require_relative './lib/post'
require 'pry'

set :css_dir,         'stylesheets'
set :js_dir,          'javascripts'
set :images_dir,      'images'
set :relative_links,  true
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, underline: true

activate :directory_indexes

activate :syntax

page 'blog/*',        layout: :post
page 'poetry.*',      layout: :category
page 'quotations.*',  layout: :category
page 'books.*',       layout: :category
page 'ninjatennis.*', layout: :category
page 'programming.*', layout: :category
page 'three-musics.*', layout: :category
page 'til.*',           layout: :category

configure :build do
  activate :minify_css
  activate :minify_javascript   # Minify Javascript on build
  activate :asset_hash          # Enable cache buster
  activate :relative_assets
end

helpers do
  def home_path;        '/'             end
  def quote_path;       '/quotations'   end
  def poetry_path;      '/poetry'       end
  def books_path;       '/books'        end
  def ninjatennis_path; '/ninjatennis'  end
  def programming_path; '/programming'  end
  def threemusics_path; '/three-musics' end
  def til_path;         '/til'          end

  def path_for(category)
    route_path = Category.new(category).route_path
    self.send(route_path)
  end

  def path_exists?(category)
    path = Category.new(category).route_path
    self.send(path)
    true
  rescue
    false
  end

  def formatted_date(date)
    date.strftime("%b %d")
  end

  def full_date(date)
    date.strftime("%b %d, %Y")
  end

  def posts_for_category(name)
    by_category = Post.by_category
    for_category = by_category[name]
    PostCollection.new(for_category).by_year
  end

  def created_at
    Post.new(current_page.source_file).date
  end
end
