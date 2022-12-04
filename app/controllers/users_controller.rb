class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[me]
  before_action :redirect_authenticated_user!, only: %i[new create]

  def new
    @user_from ||= Users::CreateForm.new

    render :new, layout: 'login_layout'
  end

  def create
    create_params = params.require(:user).permit(:login, :token)
    case Users::CreateUser.new.(create_params)
    in Success(user)
      cookies.permanent.encrypted[:_user] =
        { login: create_params[:login], token: create_params[:token] }.to_json

      redirect_to me_users_path, notice: 'User was successfully created.'
    in Failure(user_form: user_form, errors: errors)
      @user_form = user_form
      @errors = errors

      flash.now[:alert] = 'Check your data and try again.'

      respond_to do |format|
        format.turbo_stream do
          render(
            turbo_stream: [set_flash, turbo_stream.replace(:sign_up_form, partial: 'users/sign_up_form')]
          )
        end
        format.html do
          render :new, layout: 'login_layout'
        end
      end
    end
  end

  def me
    @user = current_user
    @wallets = @user.wallets
  end
end
