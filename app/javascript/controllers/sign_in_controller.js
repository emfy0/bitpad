import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sing-in"
export default class extends Controller {
  static targets = [ "token" ];

  randomHex(length){
    return Array
      .from(crypto.getRandomValues(new Uint8Array(length / 2)))
      .map(b => b.toString(16).padStart(2, '0')).join('');
  }

  generateToken() {
    this.tokenTarget.value = this.randomHex(32);
  }
}
