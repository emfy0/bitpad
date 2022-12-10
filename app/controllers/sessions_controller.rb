class SessionsController < ApplicationController
  before_action :redirect_authenticated_user!, only: %i[new create]

  def new
    @user_form ||= Users::SignInForm.new

    render :new, layout: 'login_layout'
  end

  def create
    create_params = params.require(:user).permit(:login, :token)

    user = User.find_by(login: create_params[:login])

    if user&.authenticate_token(create_params[:token])
      cookies.permanent.encrypted[:_user] =
        { login: create_params[:login], token: create_params[:token] }.to_json

      redirect_to me_users_path, notice: 'User was successfully logged in.'
    else
      @user_form = Users::SignInForm.new(create_params)
      flash.now[:alert] = 'Incorrect login or token.'

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: set_flash
        end
      end
    end
  end

  def destroy
    cookies.delete(:_user)

    redirect_to root_path, notice: 'User was successfully logged out.'
  end
end
