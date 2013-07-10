class PostsController < ApplicationController
  before_filter :require_login, :except =>[:show, :index]

  def index
    redirect_to posts_path(sort: "recent") if !params[:sort]
    @posts = if params[:sort] == "popular"
      Post.order('views DESC')
    elsif params[:sort] == "recent"
      Post.order('created_at DESC')
    end
  end

  def show
    @post = Post.find(params[:id])
    @post.views += 1
    @post.save
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :fenced_code_blocks => true)
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params[:post])
    @post.categorize
    @post.adjust_title

    if @post.save
      redirect_to @post
    else
      render action: 'new'
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to @post
    else
      render action: "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_url
  end

  private
  def require_login
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      md5_of_password = Digest::MD5.hexdigest(password)
      username == 'mehulkar' && md5_of_password == '0ccbfd202131ce37047e7974db697b94'
    end
  end
end
