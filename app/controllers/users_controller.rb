class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit]
  
  def index
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    flash[:success] = 'ユーザー登録を解除しました'
    redirect_to root_url
  end
  

  private

  def user_params
    params.require(:user).permit(:name, :age, :email, :password, :password_confirmation)
  end
end
