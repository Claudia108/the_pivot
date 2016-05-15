class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      role_redirect
    else
      flash.now[:error] = "Invalid. Please try again."
      render :new
    end
  end

  def show
    @user = current_user
    render file: '/public/404' if current_user.nil?
    render 'users/platform_admin' if current_user.platform_admin?
    render 'users/store_admin' if current_user.store_admin?

    #will default to show.html.erb (if guest)
  end

  def edit
    render file: '/public/404'
  end

  private

  def role_redirect
    if @user.platform_admin?
      flash[:notice] = "Welcome Super #{@user.first_name}"
      redirect_to platform_admin_dashboard_path
    elsif @user.store_admin?
      flash[:notice] = "Welcome #{@user.first_name}"
      redirect_to store_admin_dashboard_path
    else
      flash[:notice] = "Account Created! Logged in as #{@user.first_name}"
      redirect_to dashboard_path
    end
  end

  def user_params
    params.require(:user).permit(
                          :first_name,
                          :last_name,
                          :email,
                          :password,
                          :password_confirmation)
  end
end
