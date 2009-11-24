class ServiceController < ApplicationController

  before_filter :require_user
  
  def preview
    chapter = Chapter.new(params[:chapter])
    html = Transformer.new(chapter).transform
    render :json => {'preview-zone' => html}, :callback => 'replace_elements', :layout => false
  end
end
