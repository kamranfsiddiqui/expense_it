class ExpensesController < ApplicationController
  before_action :authenticate_user!, except: :index

  def expense_params
    params.require(:expense).permit(:name, :date, :amount, :description)
  end

  def index
    @user = User.find(params[:user_id])
    @allowed = @user.id == current_user.id
	  if !user_signed_in?
      flash[:warning] = "You need to sign-in first"
      redirect_to new_user_session_path
    elsif @allowed or current_user.admin?
    	  @expenses = @user.expenses
    else
      flash[:warning] = "You cannot access this user's expenses"
      redirect_to user_expenses_path(current_user)
		end
  end

  def new
    @user = User.find(params[:user_id])
    @allowed = @user.id == current_user.id
	  if !user_signed_in?
      flash[:warning] = "You need to sign-in first"
      redirect_to new_user_session_path
    elsif !@allowed
      flash[:warning] = "You are not allowed to create expenses for this user!"
      redirect_to user_path(@user)
    else
      @expense = Expense.new
    end
  end

  def create
    @user = User.find(params[:user_id])
    @expense = @user.expenses.new(expense_params)
    if not user_signed_in   
      flash[:warning] = "You need to sign-in first"
      redirect_to new_user_session_path
    end
    @allowed = @user.id == current_user.id
    if not @allowed  
      flash[:warning] = "You are not allowed to add expenses for this user!"
      redirect_to user_path(@user)
    end
    if @expense.save
      flash[:success] = "New expense added successfully"
      redirect_to user_expenses_path(@user, @secret)
    else
      flash[:error] = "Sorry, there was an error in adding the expense. Please try again."
      redirect_to user_path(@user)
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @allowed = @user.id == current_user.id
	  if !user_signed_in?
      flash[:warning] = "You need to sign-in first"
      redirect_to new_user_session_path
    elsif !@allowed
      flash[:warning] = "You are not allowed to edit expenses for this user!"
      redirect_to user_path(@user)
    else
      @expense = Expense.find(params[:id])
    end

  end

  def update
    @expense = Expense.find(params[:id])
    if not user_signed_in   
      flash[:warning] = "You need to sign-in first"
      redirect_to new_user_session_path
    end
    @allowed = @user.id == current_user.id
    if not @allowed  
      flash[:warning] = "You are not allowed to edit expenses for this user!"
      redirect_to user_path(@user)
    end

    if @expense.update(expense_params)
      flash[:success] = "Expense edited successfully."
      redirect_to user_expense_path(current_user, @expense)
    else
      flash[:error] = "Expense was not edited successfully. Please try again."
      redirect_to edit_user_secret_path(current_user, @expense)
    end
  end

  def show
    @user = User.find(params[:user_id])
    @allowed = @user.id == current_user.id
    @expense = Expense.find(params[:id])
	  if !user_signed_in?
      flash[:warning] = "You need to sign-in first"
      redirect_to new_user_session_path
    elsif !@allowed and !current_user.admin?
      flash[:warning] = "You cannot see this users expenses!"
      redirect_to user_path(@user)
    else
      @expense = Expense.find(params[:id])
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @allowed = @user.id == current_user.id
    if !user_signed_in?
      flash[:warning] = "You need to sign-in first"
      redirect_to new_user_session_path
    elsif !@allowed
      flash[:warning] = "You can't delete this user's  secrets"
      redirect_to user_path(current_user)
    else
      @expense = Expense.find(params[:id])
      if @expense.destroy
        flash[:success] = "The secret was successfully destroyed"
        redirect_to user_expenses_path(current_user)
      else
        flash[:error] = "Sorry could not destory the secret. Please try again."
        redirect_to user_expense_path(current_user, @expense)
      end
    end
  end

  def report
    if user_signed_in?
      @user = User.find(params[:user_id])
    end
    panel_types = Array["default", "primary", "success", "info", "warning", "danger"]
    @panel = panel_types.sample.prepend("panel panel-")
    if not Expense.exists?
      flash[:error] = "You have not added any expenses yet."
      redirect_to report_user_path(current_user)
    elsif params.has_key?("all_expenses") and params["all_expenses"]== "1"
      @startDate = Expense.where(user_id: current_user.id).order(id: :asc).first.date
      @endDate = Expense.where(user_id: current_user.id).order(id: :asc).last.date
      @weekly_sums = Expense.sum_all_expenses(current_user.id)
    else
      start = Hash[params[:start_date].map{|k,v| [k.to_sym, v.to_i]}]
      last = Hash[params[:end_date].map{|k,v| [k.to_sym, v.to_i]}]
      @startDate = DateTime.new(start[:year], start[:month], start[:day], start[:hour], start[:minute])
      @endDate = DateTime.new(last[:year], last[:month], last[:day], last[:hour], last[:minute])
      @weekly_sums = Expense.sum_time_interval_expenses current_user.id, @startDate, @endDate
    end
  end  

end
