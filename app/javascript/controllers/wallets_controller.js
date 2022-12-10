import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="wallets"
export default class extends Controller {
  static values = { updateWalletsUrl: String, updateOpenStateUrl: String };

  connect() {
    this.updateWalletsInterval = setInterval(() => this.updateWallets(), 15000);
  }

  updateWallets() {
    fetch(this.updateWalletsUrlValue);
  }

  openTx(event) {
    fetch(this.updateOpenStateUrlValue, {
      method: "post",
      credentials: 'include',
      body: new URLSearchParams({
        'hashed_id': event.target.dataset.walletHashedId,
        'tx_oppened': !event.target.closest("details").hasAttribute("open")
      })
    });
  }

  openWallet(event) {
    fetch(this.updateOpenStateUrlValue, {
      method: "post",
      credentials: 'include',
      body: new URLSearchParams({
        'hashed_id': event.target.dataset.walletHashedId,
        'oppened': !event.target.closest("details").hasAttribute("open")
      })
    });
  }

  disconnect() {
    clearInterval(this.updateWalletsInterval);
  }
}
