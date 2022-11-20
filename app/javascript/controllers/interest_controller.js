import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["button"];

  static values = {
    ui: Object
  };

  connect() {
    console.log ('Hello, from Interest Controller!');
  }

  toggle() {
    this.buttonTarget.classList.toggle('btn-light')
    this.buttonTarget.classList.toggle('btn-primary');
  }
}
