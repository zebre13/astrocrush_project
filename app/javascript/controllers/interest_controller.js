import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["button"];

  connect() {
    console.log ('Hello, from Interest Controller!');
  }

  update(event) {
    fetch('/user_interests', {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify({"user": event.params.userId, "interest": event.params.interestId})
    })

    this.buttonTarget.classList.toggle('btn-light');
    this.buttonTarget.classList.toggle('btn-primary');

  }
}
