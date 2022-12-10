class WalletsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :update_open_state

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
      end
    end
  end

  def new_generate
    @wallet_form ||= Wallets::GenerateForm.new
  end

  def generate
    greate_params = params.require(:wallet).permit(:name)

    case Wallets::GenerateWallet.new.(params: greate_params, current_user:, token:)
    in Success(wallet:, base58:)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            set_flash,
            turbo_stream.replace('generate-wallet', partial: 'wallets/newly_generated', locals: { wallet:, base58: })
          ]
        end
      end
    in Failure(wallet_form: wallet_form, errors: errors)
      @wallet_form = wallet_form
      @errors = errors

      flash.now[:alert] = 'Check your data and try again.'

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [set_flash, turbo_stream.replace(:wallet_form, partial: 'wallets/generate_form')]
        end
      end
    end
  end

  def destroy
    w = Wallet.where(hashed_id: params[:hashed_id], user: current_user).first

    flash.now[:alert] =
      if w.destroy
        'Wallet was successfully destroyed.'
      else
        'Something went wrong.'
      end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [set_flash]
      end
    end
  end

  def update_open_state
    update_open_state_params = params.permit(:hashed_id, :oppened, :tx_oppened)

    params_for_update =
      update_open_state_params.slice(:oppened, :tx_oppened).to_h.each_with_object({}) do |(k, v), hash|
        hash[k] = v if v.present?
      end

    Wallet
      .where(hashed_id: update_open_state_params[:hashed_id], user: current_user)
      .update_all(params_for_update)

    head :ok
  end
end
