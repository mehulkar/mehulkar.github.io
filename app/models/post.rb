class Post < ActiveRecord::Base
  validates_presence_of :title, :body
  belongs_to :category

  # TODO: Make this not messy and not make assumptions about existing categories.
  def categorize
    if self.title.downcase.include? "quote" or self.title.include? "quotation"
      self.category_id = Category.where(name: "Quotation").first.id
    elsif self.title.downcase.include? "epiphany"
      self.category_id = Category.where(name: "Epiphany").first.id
    else
      self.category_id = nil
    end
  end

  # We want to add a number to titles if the post is categorized a quote or an epiphany
  def adjust_title
    if self.category
      category = find_category_by_name(self.category.name)

      last_post_in_category = last_assigned_post_in_category(category.id)
      if last_post_in_category
        num = last_post_in_category.title.split("#")[1].to_i + 1
        self.title = category.name + " ##{num.to_s}"
      else
        self.title = category.name + " #1"
      end
    end
  end

  def find_category_by_name(name)
    Category.where(name: name).first
  end

  def last_assigned_post_in_category(category_id)
    posts = Post.where(category_id: category_id)
    posts.last if !posts.empty?
  end
end
