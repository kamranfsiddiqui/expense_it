class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def user_params
    params.require(:user).permit(:password, :email, expenses_attributes: [:date, :amount, :description])
  end

  def index
    if not user_signed_in? or not current_user.admin?
      redirect_to new_user_session_path
    elsif not current_user.admin?
      redirect_to user_path(current_user.id)  
    else
      @users = User.all
    end
  end

  def new
    if user_signed_in?
      redirect_to user_path(current_user.id)
    else
      redirect_to new_user_session_path
    end
  end

  def create
    User.new(user_params)
  end

  def edit
    @user = User.find(params[:id])
    @allowed = @user.id == current_user.id
	  if !@allowed
      flash[:warning] = "You cannot edit another user's settings expenses"
      redirect_to user_path(current_user)
		end
    
  end

  def update
    @user = User.find(params[:id])
    @allowed = @user.id == current_user.id
	  if !@allowed
      flash[:warning] = "You cannot edit another user's settings expenses"
      redirect_to user_path(current_user)
    else
      redirect_to edit_user_path(@user)
		end
  end

  def show
    @user = User.find(params[:id])
    @allowed = @user.id == current_user.id
	  if !@allowed
      flash[:warning] = "You cannot access another user's expenses"
      redirect_to user_path(current_user)
    else
      redirect_to user_expenses_path(@user)
		end
  end

  def destroy
    @user = User.find(params[:id])
    @allowed = @user.id == current_user.id
	  if !@allowed
      flash[:warning] = "You cannot delete another user"
      redirect_to user_path(current_user)
    else
      redirect_to new_user_session_path
		end
  end

  def report
      @user = User.find(params[:id])
  end

end
