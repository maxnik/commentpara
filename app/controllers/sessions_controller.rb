class SessionsController < ApplicationController

  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = t('session.created')
      redirect_back_or_default '/'
    else
      render :action => 'new'
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = t('session.destroyed')
    redirect_back_or_default '/'
  end
end
