require 'dry/transaction'

class Users::CreateUser
  include Dry::Transaction

  step :validate_params
  step :create_user

  private

  def validate_params(params)
    user_form = Users::CreateForm.new(params)

    if user_form.validate
      Success(params: user_form.attributes, user_form:)
    else
      Failure(user_form:, errors: user_form.errors)
    end
  end

  def create_user(params:, user_form:)
    new_user = User.create(params)

    if new_user.valid?
      Success(new_user)
    else
      Failure(user_form:, errors: new_user.errors)
    end
  end
end
