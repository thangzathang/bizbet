class ApplicationController < ActionController::Base

    helper_method :current_user, :logged_in?

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
        # We have just turned this method into a boolean - it will return true or false
        !!current_user
    end
 
end
