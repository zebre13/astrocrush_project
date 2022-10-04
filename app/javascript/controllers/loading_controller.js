import { Controller } from "stimulus"

export default class extends Controller {

  connect() {
    this.outputTarget.textContent = 'Hello, Stimulus!'
  }

  load() {
    console.log('Hello, Stimulus!')
  }
}
