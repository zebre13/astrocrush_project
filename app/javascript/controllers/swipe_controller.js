import { Controller } from "@hotwired/stimulus"
import "swipe-listener"
import UseStrictPlugin from "webpack/lib/UseStrictPlugin"
export default class extends Controller {
  static targets = ["list","user"]

  connect() {
    console.log("Hello from our first Stimulus controller")
    const firstUser = document.querySelector(".carousel-item")
    console.log(firstUser)
    firstUser.classList.add("active")
  }


  swipeLeft(){
    // recupérer l'user active
    const activeUser = document.querySelector(".carousel-item.active")
    activeUser.classList.remove("active")

    // récupérer l'user suivant

    const nextUser = activeUser.nextElementSibling
    nextUser.classList.add("active")
    }

  swipeRight(){
    const url= "/matches"
    const mateId = parseInt(document.querySelector(".carousel-item.active > div").dataset.mateId, 10)
    fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({"id": mateId})
    })

    this.swipeLeft()
  }
}






// Quand swipe, détoggle la classe active actuelle  mettre la classe active sur l'element suivant
