class CommentsController < ApplicationController

  before_filter :require_user, :only => :destroy
  before_filter :prepare_page, :only => [:index, :show]

  def index
    @comments = Comment.paginate(:all, 
                                 :include => 'chapter', 
                                 :order => 'created_at DESC',
                                 :page => @page, 
                                 :per_page => Comment.all_per_page)
  end

  def show
    @chapter = Chapter.find(params[:chapter_id])
    @commentable_id = params[:commentable_id]

    respond_to do |format|
      format.js do
        @comments = @chapter.comments.for_commentable(@commentable_id).paginate(:page => @page)
        
        if params[:page]
          render :json => {"comments-#{@chapter.id}-#{@commentable_id}" =>
                           render_to_string(:partial => 'comments')},
                 :callback => 'replace_elements'
        else
          render :json => {"comments-zone-#{@chapter.id}-#{@commentable_id}" =>
                           render_to_string(:template => 'comments/zone', :layout => false)},
                 :callback => 'fill_comment_form'
        end
      end
      format.html do        
        @comments = @chapter.comments.for_commentable(@commentable_id)
      end
    end
  end

  def create
    @chapter = Chapter.find(params[:chapter_id])
    @comment = @chapter.comments.new(params[:comment])
    @comment.commentable_id = params[:commentable_id]

    respond_to do |format|
      if @comment.save
        format.js do
          render :json => {"comments-zone-#{@comment.chapter_id}-#{@comment.commentable_id}" => nil},
                 :callback => 'hide_comment_form'
        end
      else
        errors = @comment.errors.inject({}) do |errs, (field, message)| 
          errs["#{field}-error-#{@comment.chapter_id}-#{@comment.commentable_id}"] = message
          errs
        end
        format.js do
          render :json => errors, :callback => 'replace_elements'
        end
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.js do
        render :json => {"comment-#{@comment.id}" => I18n.t('comment.deleted')},
               :callback => 'replace_elements'
      end
    end
  end

  private 

  def prepare_page
    @page = params[:page].to_i
    @page = 1 if @page == 0
  end
end
