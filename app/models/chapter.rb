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
      # get comments count for all commentables for this chapter_id
      self.body_html = Transformer.new(self).transform do |commentable_id|
        0 # comments_count[commentable_id]
      end
    end
    true
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end
end


