import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-wallet-modal"
export default class extends Controller {
  static targets = ['modal']

  clickOutside() {
    this.close();
  }

  close() {
    this.modalTarget.setAttribute('open', false);
  }

  open() {
    this.modalTarget.setAttribute('open', true);
  }
}
