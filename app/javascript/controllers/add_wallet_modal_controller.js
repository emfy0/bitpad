import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-wallet-modal"
export default class extends Controller {
  static targets = [ "modal" ]

  close() {
    this.modalTarget.setAttribute("open", false);
  }

  open() {
    this.modalTarget.setAttribute("open", true);
  }
}
