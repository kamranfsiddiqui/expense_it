class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_up_path_for(user)
      users_path 
  end

  def after_sign_in_path_for(user)
      user_expenses_path(current_user)
  end

  def after_sign_out_path_for(user)
    root_path
  end

  def render_401
    render file: "#{Rails.root}/public/401.html"
  end
  def render_404
    render file: "#{Rails.root}/public/404.html"
  end
end
