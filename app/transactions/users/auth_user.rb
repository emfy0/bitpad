require 'dry/transaction'

class Users::AuthUser
  include Dry::Transaction

  step :find_user
  step :authenticate_token

  private

  def find_user(user_cookie)
    return Failure(:user_not_found) unless user_cookie

    if (user = User.find_by(login: user_cookie[:login]))
      Success(user:, token: user_cookie[:token])
    else
      Failure(:user_not_found)
    end
  end

  def authenticate_token(user:, token:)
    if user.authenticate_token(token)
      Success(user:, token:)
    else
      Failure(:token_not_valid)
    end
  end
end
