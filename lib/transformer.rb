class Transformer

  include ActionController::UrlWriter

  def initialize(chapter)
    @chapter = chapter
  end

  def transform
    html = RDiscount.new(@chapter.body).to_html
    commentable_id = 0
    html.gsub! /<(p|pre|ol|ul)>(.*?)<\/\1>/m  do
      commentable_id += 1
      commentable_tag, content = $1, $2

      comments_count = block_given? ? (yield commentable_id) : 0
      comments_text = self.class.comments_count_to_text(comments_count)
      comments_link = "<a class=\"comment-link\" id=\"comments-count-%d-%d\" href=\"%s\">%s</a>" %
                      [@chapter.id, commentable_id, show_comments_path(@chapter.id.to_i, commentable_id), comments_text];

      "<#{commentable_tag} class=\"commentable\" id=\"c-#{commentable_id}\">" \
        "#{content}" \
        "#{comments_link}" \
      "</#{commentable_tag}>" \
      "<div class=\"comments-zone\" id=\"comments-zone-#{@chapter.id}-#{commentable_id}\"></div>"
    end
    html
  end

  def replace_comments_link(commentable_id, comments_count)
    @chapter.body_html.sub(/(<a.*?comments-count-#{@chapter.id}-#{commentable_id}.*?>).*?(<\/a>)/m) do |_|
      "%s%s%s" % [$1, self.class.comments_count_to_text(comments_count), $2]
    end
  end

  def self.comments_count_to_text(comments_count)
    if comments_count == 0
      I18n.t('comment.no_comments')
    else 
      I18n.t('comment', :count => comments_count)
    end
  end
end
