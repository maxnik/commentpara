class Chapter < ActiveRecord::Base

  has_many :comments

  attr_accessible :title, :body

  validates_presence_of :title
  validates_length_of :title, :maximum => 255, :if => Proc.new {|c| c.errors.on(:title).blank? }

  def after_create
    self.body_html = Transformer.new(self).transform
    update_without_callbacks
  end

  def before_update
    if body_changed?
      comments = self.comments.find(:all,
                                    :select => 'commentable_id, COUNT(id) as comments_count',
                                    :group => 'commentable_id')
      comments_count = comments.inject({}) do |cc, comment| 
        cc[comment.commentable_id] = comment.comments_count
        cc
      end
      self.body_html = Transformer.new(self).transform do |commentable_id|
        comments_count[commentable_id].to_i
      end
    end
    true
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end
end


