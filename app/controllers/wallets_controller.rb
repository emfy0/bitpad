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

  def new_import
    @wallet_form ||= Wallets::ImportForm.new
  end

  def import
    import_params = params.require(:wallet).permit(:base58)

    case Wallets::ImportWallet.new.(import_params, current_user)
    in Success(wallet)
      redirect_to me_users_path, notice: 'Wallet was successfully imported.'
    else
      flash.now[:alert] = 'Check your data and try again.'

      render :import
    end
  end
end
