class Comment < ActiveRecord::Base

  belongs_to :chapter

  attr_accessible :author, :url, :body

  validates_presence_of :author
  validates_length_of :author, :maximum => 255, :if => Proc.new {|c| c.errors.on(:author).blank? }

  validates_length_of :url, :maximum => 255, :allow_nil => true, :allow_blank => true

  validates_presence_of :body
  validates_length_of :body, :maximum => 2000, :if => Proc.new {|c| c.errors.on(:body).blank? }

  named_scope :for_commentable, (lambda do |commentable_id|
    {:conditions => {:commentable_id => commentable_id}, :order => 'created_at ASC'}
  end)

  def self.per_page
    5
  end

  def self.all_per_page
    30
  end

  after_create :replace_link_in_chapter!
  after_destroy :replace_link_in_chapter!

  private 

  def replace_link_in_chapter!
    comments_count = Comment.count(:conditions => {:chapter_id => self.chapter_id,
                                                   :commentable_id => self.commentable_id})
    updated_html = Transformer.new(self.chapter).replace_comments_link(self.commentable_id, comments_count)
    self.chapter.update_attribute('body_html', updated_html)
  end
end
