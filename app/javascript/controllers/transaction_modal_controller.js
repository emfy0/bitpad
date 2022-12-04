import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transaction"
export default class extends Controller {
  static targets = [ "modal", "feeRange", "feeShow" ]

  close() {
    this.modalTarget.setAttribute("open", false);
  }

  open(event) {
    this.transactionBytes = event.currentTarget.dataset.transactionBytes;
    this.updateChosenFee();
    this.modalTarget.setAttribute("open", true);
  }

  updateChosenFee() {
    this.feeShowTarget.innerHTML = `${this.feeRangeTarget.value} sat/byte ~ ${this.feeRangeTarget.value * this.transactionBytes} sat`;
  }
}
