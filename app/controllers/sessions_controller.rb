class SessionsController < ApplicationController

  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    if User.count == 0
      User.new(:email => params[:user_session][:email],
               :password => params[:user_session][:password],
               :password_confirmation => params[:user_session][:password]).save!
    end
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
