require 'dry/transaction'

class Users::CreateUser
  include Dry::Transaction

  step :validate_params
  step :create_user

  private

  def validate_params(params)
    user_from = Users::CreateForm.new(params)

    if user_from.validate
      Success(params)
    else
      Failure(user_from:, errors: user_from.errors)
    end
  end

  def create_user(params)
    Success(User.create(params))
  end
end
