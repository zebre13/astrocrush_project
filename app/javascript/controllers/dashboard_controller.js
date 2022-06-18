import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["horoscope", "profile", "compatibilities", "table", "circle"]

  connect() {
    console.log("Hello from our first Stimulus controller")
  }

  horoscope() {
    this.horoscopeTarget.classList.remove("d-none");
    this.profileTarget.classList.remove("d-none");
    this.compatibilitiesTarget.classList.remove("d-none");
    this.tableTarget.classList.remove("d-none");
    this.circleTarget.classList.remove("d-none");
    this.profileTarget.classList.add("d-none");
    this.compatibilitiesTarget.classList.add("d-none");
    this.tableTarget.classList.add("d-none");
    this.circleTarget.classList.add("d-none");
  }

  profile() {
    this.profileTarget.classList.remove("d-none");
    this.horoscopeTarget.classList.remove("d-none");
    this.compatibilitiesTarget.classList.remove("d-none");
    this.tableTarget.classList.remove("d-none");
    this.circleTarget.classList.remove("d-none");
    this.horoscopeTarget.classList.add("d-none");
    this.compatibilitiesTarget.classList.add("d-none");
    this.tableTarget.classList.add("d-none");
    this.circleTarget.classList.add("d-none");
  }

  compatibilities() {
    this.compatibilitiesTarget.classList.remove("d-none");
    this.horoscopeTarget.classList.remove("d-none");
    this.profileTarget.classList.remove("d-none");
    this.tableTarget.classList.remove("d-none");
    this.circleTarget.classList.remove("d-none");
    this.horoscopeTarget.classList.add("d-none");
    this.profileTarget.classList.add("d-none");
    this.tableTarget.classList.add("d-none");
    this.circleTarget.classList.add("d-none");
  }

  circle() {
    this.circleTarget.classList.remove("d-none");
    this.horoscopeTarget.classList.remove("d-none");
    this.profileTarget.classList.remove("d-none");
    this.compatibilitiesTarget.classList.remove("d-none");
    this.tableTarget.classList.remove("d-none");
    this.horoscopeTarget.classList.add("d-none");
    this.profileTarget.classList.add("d-none");
    this.compatibilitiesTarget.classList.add("d-none");
    this.tableTarget.classList.add("d-none");
  }

  table() {
    this.tableTarget.classList.remove("d-none");
    this.horoscopeTarget.classList.remove("d-none");
    this.profileTarget.classList.remove("d-none");
    this.compatibilitiesTarget.classList.remove("d-none");
    this.circleTarget.classList.remove("d-none");
    this.horoscopeTarget.classList.add("d-none");
    this.profileTarget.classList.add("d-none");
    this.compatibilitiesTarget.classList.add("d-none");
    this.circleTarget.classList.add("d-none");
  }
}
