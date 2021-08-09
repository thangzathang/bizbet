class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    # These two line of code authorises urls 
    before_action :require_user, only: [:edit, :update]
    before_action :require_same_user, only: [:edit, :update, :destroy]

    def show
        # @user = User.find(params[:id])
        @articles = @user.articles.paginate(page: params[:page], per_page: 4)
    end

    def index 
        # @users = User.all
        @users = User.paginate(page: params[:page], per_page: 3)
    end

    def new 
        @user = User.new
    end

    def edit
        # @user = User.find(params[:id])
    end

    def update 
        # @user = User.find(params[:id])
        if @user.update(user_params)
            flash[:notice] = "Your account was updated!"
            redirect_to user_path(@user)
        else
            render 'edit'
        end
    end

    def create
        @user = User.new(user_params)
        if @user.save 
            session[:user_id] = @user.id
            flash[:notice] = "Welcome #{@user.username.split.first().capitalize}!, you have sucessfully signed up to Alpha Blogs"
            redirect_to articles_path
        else
            render 'new' 
        end
    end

    def destroy 
        @user.destroy

        # The admin can delete their own account!
        session[:user_id] = nil if @user == current_user

        # Because the user won't exist anymore!
        flash[:notice] = "Account and all it's data has been deleted!"
        redirect_to articles_path
    end 

    private 

    def user_params 
        params.require(:user).permit(:username, :email, :password)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:alert] = "You are not authorised!"
            redirect_to @user
        end
    end

end