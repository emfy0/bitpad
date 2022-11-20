class SessionsController < ApplicationController
  def new; end

  def create
    create_params = params.require(:session).permit(:login, :token)

    user = User.find_by(login: create_params[:login])&.authenticate_token(create_params[:token])

    if user
      cookies.permanent.encrypted[:_user] = { login: create_params[:login], token: create_params[:token] }.to_json

      redirect_to user_path(user), notice: 'User was successfully logged in.'
    else
      flash.now[:alert] = 'Incorrect login or token.'

      render :new
    end
  end

  def destroy
    cookies.delete(:_user)

    redirect_to root_path, notice: 'User was successfully logged out.'
  end
end
