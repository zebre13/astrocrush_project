import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["horoscope", "profile", "score", "chart", "table", "circle", "horoscope_menu", "profile_menu", "score_menu", "chart_menu", "table_menu", "circle_menu"]

  connect() {
    console.log("Hello from our first Stimulus controller");
  }

  horoscope() {
    this.horoscopeTarget.classList.remove("d-none");

    this.profileTarget.classList.add("d-none");
    this.scoreTarget.classList.add("d-none");
    this.chartTarget.classList.add("d-none");

    this.horoscope_menuTarget.classList.add("lead");

    this.profile_menuTarget.classList.remove("lead");
    this.score_menuTarget.classList.remove("lead");
    this.chart_menuTarget.classList.remove("lead");
  }

  profile() {
    this.profileTarget.classList.remove("d-none");

    this.horoscopeTarget.classList.add("d-none");
    this.scoreTarget.classList.add("d-none");
    this.chartTarget.classList.add("d-none");

    this.profile_menuTarget.classList.add("lead");

    this.horoscope_menuTarget.classList.remove("lead");
    this.score_menuTarget.classList.remove("lead");
    this.chart_menuTarget.classList.remove("lead");
  }

  score() {
    this.scoreTarget.classList.remove("d-none");

    this.horoscopeTarget.classList.add("d-none");
    this.profileTarget.classList.add("d-none");
    this.chartTarget.classList.add("d-none");

    this.score_menuTarget.classList.add("lead");

    this.horoscope_menuTarget.classList.remove("lead");
    this.profile_menuTarget.classList.remove("lead");
    this.chart_menuTarget.classList.remove("lead");
  }

  chart() {
    this.chartTarget.classList.remove("d-none");

    this.horoscopeTarget.classList.add("d-none");
    this.profileTarget.classList.add("d-none");
    this.scoreTarget.classList.add("d-none");

    this.chart_menuTarget.classList.add("lead");

    this.horoscope_menuTarget.classList.remove("lead");
    this.profile_menuTarget.classList.remove("lead");
    this.score_menuTarget.classList.remove("lead");
  }

  circle() {
    this.circleTarget.classList.remove("d-none");

    this.horoscopeTarget.classList.add("d-none");
    this.profileTarget.classList.add("d-none");
    this.scoreTarget.classList.add("d-none");
    this.tableTarget.classList.add("d-none");

    this.circle_menuTarget.classList.add("lead");

    this.horoscope_menuTarget.classList.remove("lead");
    this.score_menuTarget.classList.remove("lead");
    this.profile_menuTarget.classList.remove("lead");
    this.table_menuTarget.classList.remove("lead");
  }

  table() {
    this.tableTarget.classList.remove("d-none");

    this.horoscopeTarget.classList.add("d-none");
    this.profileTarget.classList.add("d-none");
    this.scoreTarget.classList.add("d-none");
    this.circleTarget.classList.add("d-none");

    this.table_menuTarget.classList.add("lead");

    this.horoscope_menuTarget.classList.remove("lead");
    this.score_menuTarget.classList.remove("lead");
    this.circle_menuTarget.classList.remove("lead");
    this.profile_menuTarget.classList.remove("lead");
  }
}
