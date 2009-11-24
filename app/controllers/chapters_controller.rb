class ChaptersController < ApplicationController
  
  before_filter :require_user, :except => [:index, :show]

  def index
    @chapters = Chapter.find(:all, :order => 'created_at DESC')
  end

  def show
    @chapter = Chapter.find(params[:id])
    @title = @chapter.title
  end

  def new
    @chapter = Chapter.new
    render :action => 'new_edit'
  end

  def create
    @chapter = Chapter.new(params[:chapter])
    if @chapter.save
      redirect_to(chapters_url)
    else
      render :action => 'new_edit'
    end
  end

  def edit
    @chapter = Chapter.find(params[:id])
    render :action => 'new_edit'
  end

  def update
    @chapter = Chapter.find(params[:id])
    if @chapter.update_attributes(params[:chapter])
      redirect_to chapters_url
    else
      render :action => 'new_edit'
    end
  end

  def delete
  end
end
