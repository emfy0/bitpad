class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def post
    case Transactions::Post.new.(
      params: post_params,
      current_user:,
      token:
    )
    in Success(transaction)
      flash.now[:notice] = 'Transaction was broadcasted.'

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            set_flash,
            turbo_stream.replace(
              'transaction_form',
              partial: 'users/transaction_modal',
              locals: { transaction_form: Transactions::PostForm.new, errors: nil, oppened: false }
            )
          ]
        end
      end
    in Failure[:transaction_wasnt_broadcasted, errors]
      redirect_to me_users_path, alert: "Transaction wasnt broascasted. #{errors}"
    in Failure[:no_such_wallet_for_user | :invalid_token, _]
      raise ActionController::InvalidAuthenticityToken
    in Failure(transaction_form:, errors:)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              'transaction_form',
              partial: 'users/transaction_modal',
              locals: { transaction_form:, errors:, oppened: true }
            )
          ]
        end
      end
    end
  end

  private

  def post_params
    params.require(:transaction).permit(:fee_rate, :recipient_address, :volume, :hashed_id)
  end
end
