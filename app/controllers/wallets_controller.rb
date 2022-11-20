class WalletsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wallets = current_user.wallets
  end

  def show
    @wallet = current_user.wallets.find_by(hashed_id: params[:id])
  end

  private

  def authenticate_user!
    redirect_to sessions_path unless current_user
  end
end
