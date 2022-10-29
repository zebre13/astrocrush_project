import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["horoscope", "profile", "score", "table", "circle", "horoscope_menu", "profile_menu", "score_menu", "table_menu", "circle_menu"]

  connect() {
    console.log("Hello from our first Stimulus controller");
  }

  hover(target) {
    target.classList.add("nav-hov")

    if (target !== this.horoscope_menuTarget) {
      this.horoscope_menuTarget.classList.remove("nav-hov")
    }

    if (target !== this.profile_menuTarget) {
      this.profile_menuTarget.classList.remove("nav-hov")
    }

    if (target !== this.score_menuTarget) {
      this.score_menuTarget.classList.remove("nav-hov")
    }
  }

  horoscope() {
    this.hover(this.horoscope_menuTarget)
    this.horoscopeTarget.classList.remove("d-none");
    this.horoscope_menuTarget.classList.add("lead");

    this.profileTarget.classList.add("d-none");
    this.profile_menuTarget.classList.remove("lead");

    this.scoreTarget.classList.add("d-none");
    this.score_menuTarget.classList.remove("lead");
  }

  profile() {
    this.hover(this.profile_menuTarget)
    this.profileTarget.classList.remove("d-none");
    this.profile_menuTarget.classList.add("lead");

    this.horoscopeTarget.classList.add("d-none");
    this.horoscope_menuTarget.classList.remove("lead");

    this.scoreTarget.classList.add("d-none");
    this.score_menuTarget.classList.remove("lead");
  }

  circle() {
    this.circleTarget.classList.remove("d-none");
    this.circle_menuTarget.classList.add("lead");

    this.tableTarget.classList.add("d-none");
    this.table_menuTarget.classList.remove("lead");
  }

  table() {
    this.tableTarget.classList.remove("d-none");
    this.table_menuTarget.classList.add("lead");

    this.circleTarget.classList.add("d-none");
    this.circle_menuTarget.classList.remove("lead");
    }

  score() {
    this.hover(this.score_menuTarget)
    this.scoreTarget.classList.remove("d-none");
    this.score_menuTarget.classList.add("lead");

    this.horoscopeTarget.classList.add("d-none");
    this.horoscope_menuTarget.classList.remove("lead");

    this.profileTarget.classList.add("d-none");
    this.profile_menuTarget.classList.remove("lead");
  }
}
