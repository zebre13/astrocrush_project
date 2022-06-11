import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  connect() {
    console.log("Hello from our first Stimulus controller")
  }

  go_right() {
    this.contentTarget.outerHTML = data ;
  }

  // go_left() {
  //   console.log(event)
  // }
}
