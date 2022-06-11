import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["table", "circle"]

  connect() {
    console.log("Hello from our first Stimulus controller")
  }

  circle() {
    this.circleTarget.classList.remove("d-none");
    this.tableTarget.classList.add("d-none");
  }

  table() {
    this.tableTarget.classList.remove("d-none");
    this.circleTarget.classList.add("d-none");
  }
}
