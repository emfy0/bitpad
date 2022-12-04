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

  def new_import
    @wallet_form ||= Wallets::ImportForm.new
  end

  def import
    import_params = params.require(:wallet).permit(:base58, :name)

    case Wallets::ImportWallet.new.(params: import_params, current_user:, token:)
    in Success(wallet)
      redirect_to me_users_path, notice: 'Wallet was successfully imported.'
    in Failure(wallet_form: wallet_form, errors: errors)
      @wallet_form = wallet_form
      @errors = errors

      flash.now[:alert] = 'Check your data and try again.'

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [set_flash, turbo_stream.replace(:wallet_form, partial: 'wallets/base58_form')]
        end
        format.html { render :new_import }
      end
    end
  end

  def new_generate
    @wallet_form ||= Wallets::GenerateForm.new
  end

  def generate
    greate_params = params.require(:wallet).permit(:name)

    case Wallets::GenerateWallet.new.(params: greate_params, current_user:, token:)
    in Success(wallet)
      redirect_to me_users_path, notice: 'Wallet was successfully generated.'
    in Failure(wallet_form: wallet_form, errors: errors)
      @wallet_form = wallet_form
      @errors = errors

      flash.now[:alert] = 'Check your data and try again.'

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [set_flash, turbo_stream.replace(:wallet_form, partial: 'wallets/generate_form')]
        end
        format.html { render :new_generate }
      end
    end
  end
end
