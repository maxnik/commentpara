# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  rescue_from(ActiveRecord::RecordNotFound) do |e|
    render :file => "#{RAILS_ROOT}/public/404.html", :status => '404 Not Found'
  end

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  private

  def current_user_session
    # return @current_user_session if defined?(@current_user_session)
    # @current_user_session = UserSession.find
    @current_user_session ||= UserSession.find
  end

  def current_user
    # return @current_user if defined?(@current_user)
    # @current_user = current_user_session && current_user_session.record
    @current_user ||= current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = t('user.need_registration')
      redirect_to login_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
