import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="wallets"
export default class extends Controller {
  static targets = [ "wallet" ];

  static values = { url: String };

  connect() {
    this.interval = setInterval(() => this.fetchRates(), 15000);
  }

  fetchRates() {
    fetch(this.urlValue)
      .then(response => response.json())
      .then(data => {
        this.walletTargets.forEach((wallet) => {
          wallet.getElementsByClassName('rate')[0].innerText =
            `~ ${(data['USD'] * wallet.dataset.amount).toFixed(2)} USD`;
        });
      });
  }

  disconnect() {
    clearInterval(this.interval);
  }
}
