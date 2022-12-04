require 'dry/monads'

class ApplicationController < ActionController::Base
  attr_reader :current_user, :token

  helper_method :current_user

  before_action :authenticate_user

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    cookies.delete(:_user)
    raise exception
  end

  def authenticate_user
    user_cookie =
      if (cookie = cookies.encrypted[:_user])
        JSON.parse(cookie, symbolize_names: true)
      end

    case Users::AuthUser.new.(user_cookie)
    in Success(user:, token:)
      @current_user = user
      @token = token
    else
    end
  end

  def authenticate_user!
    return if current_user

    flash[:alert] = 'You need to login to access this page.'
    redirect_to auth_sign_in_path
  end

  def redirect_authenticated_user!
    return unless current_user

    flash[:alert] = 'You are already logged in.'
    redirect_to me_users_path
  end

  def set_flash
    turbo_stream.replace(:flash, partial: 'shared/flash')
  end
end
