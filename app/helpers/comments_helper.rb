module CommentsHelper

  def comment_author_link(comment) 
    if comment.url.blank?
      "<i>#{h(comment.author)}</i>"
    else
      link_to(h(comment.author), h(comment.url), :class => 'commentator-link', :rel => 'nofollow', :target => '_blank')
    end
  end
end
