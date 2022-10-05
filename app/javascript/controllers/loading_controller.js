import { Controller } from "stimulus"
import { Modal } from "bootstrap";

export default class extends Controller {
  static targets = ['modal']

  connect() {
    this.outputTarget.textContent = 'Hello, Stimulus!'
  }

  load(e) {
    console.log('Hello, from loading!')

    const modal = new Modal(this.modalTarget)
    modal.show()
  }
}
