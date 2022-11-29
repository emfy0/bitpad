class WalletsController < ApplicationController
  before_action :authenticate_user!

  def create
    create_params = params.require(:wallet).permit(:name)

    case Wallets::CreateWallet.new.(create_params, current_user)
    in Success(wallet)
      redirect_to user_path(current_user), notice: 'Wallet was successfully created.'
    in Failure(wallet_form: wallet_form, errors: errors)
      @wallet_form = wallet_form
      @error = errors

      flash.now[:alert] = 'Check your data and try again.'

      render :new
    end
  end

  def show
    @wallet = current_user.wallets.find_by(hashed_id: params[:id])
  end

  private

  def authenticate_user!
    redirect_to sessions_path unless current_user
  end
end
