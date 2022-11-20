class ApplicationController < ActionController::Base
  attr_reader :current_user, :token

  before_action :authenticate_user

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    сookies.delete(:_user)
    raise exception
  end

  def authenticate_user
    user_cookie =
      if (cookie = cookies.encrypted[:_user])
        JSON.parse(cookie, symbolize_names: true)
      else
        nil
      end

    User::AuthUser.new.(user_cookie) do |r|
      r.success do |result|
        @current_user = result[:user]
        @token = result[:token]
      end

      r.failure {}
    end
  end
end
