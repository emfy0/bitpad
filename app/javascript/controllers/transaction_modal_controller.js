import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transaction"
export default class extends Controller {
  static targets = [ "modal", "feeRange", "feeShow", "hashedId" ]
  static values = { bytes: Number }

  close() {
    this.modalTarget.setAttribute("open", false);
  }

  open(event) {
    this.bytesValue = event.currentTarget.dataset.transactionBytes;
    this.hashedIdTarget.value = event.currentTarget.dataset.walletHashedId;
    this.updateChosenFee();
    this.modalTarget.setAttribute("open", true);
  }

  updateChosenFee() {
    this.feeShowTarget.innerHTML = `${this.feeRangeTarget.value} sat/byte ~ ${this.feeRangeTarget.value * this.bytesValue} sat`;
  }
}
