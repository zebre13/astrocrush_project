import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    console.log("hello from User Interests Controller")
  }

  update = (event) => {
    event.preventDefault()

    const arr = this.context.targetObserver.targetsByName.valuesByKey

    arr.forEach( (entrie) => {
      entrie.forEach((value) => {
        if (value.className.includes('btn-primary')) {
          fetch('/user_interests', {
              method: "POST",
              headers: {"Content-Type": "application/json"},
              body: JSON.stringify({"user": value.attributes.u.value, "interest": value.attributes.i.value})
          })
        }
        window.location.href = "/"
        // if (value.className.includes('btn-light')) {
        //   console.log("delete")
        //   fetch(`/user_interests/${ value.attributes.ui.value }`, {
        //     method: "DELETE",
        //   })
        // }
      })
    })
  }
}
