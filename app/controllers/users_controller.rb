class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy, :show]

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to root_url
  end

  def edit
    @user = current_user
  end

  def new
    @user = User.new
  end

  def show
    @user = current_user
    @entries = @user.entries
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash.now[:success] = 'Profile updated'
      render 'edit'
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # Confirms the correct user
    def correct_user
      @user = current_user
      redirect_to(root_url) unless current_user?(@user)
    end
end
