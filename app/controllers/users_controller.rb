class UsersController < ApplicationController
  def new
    @user ||= User.new
  end

  def create
    create_params = params.require(:user).permit(:login, :token)

    @user = User.new(create_params)

    if @user.save
      cookies.permanent.encrypted[:_user] = {login: create_params[:login], token: create_params[:token]}.to_json

      redirect_to user_path(@user), notice: 'User was successfully created.'
    else
      flash.now[:alert] = 'Check your data and try again.'

      render :new
    end
  end

  def show
    @user = current_user
  end
end
