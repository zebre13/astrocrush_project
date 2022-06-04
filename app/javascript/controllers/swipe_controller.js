import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "user" ]

  connect() {
    this.outputTarget.textContent = 'Hello, Stimulus!'
  }
}
