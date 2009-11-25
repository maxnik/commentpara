class ServiceController < ApplicationController

  layout false

  before_filter :require_user, :except => 'sitemap'
  
  def preview
    chapter = Chapter.new(params[:chapter])
    html = Transformer.new(chapter).transform
    render :json => {'preview-zone' => html}, :callback => 'replace_elements'
  end

  def sitemap
    @chapters = Chapter.find(:all, :select => 'id, title, updated_at')
    @comments = Comment.find(:all, :select => 'chapter_id, commentable_id', :group => 'chapter_id, commentable_id')
    render :action => 'sitemap', :content_type => 'text/xml'
  end
end
