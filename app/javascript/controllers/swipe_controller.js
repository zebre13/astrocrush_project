import { Controller } from "@hotwired/stimulus"
import "swipe-listener"
import UseStrictPlugin from "webpack/lib/UseStrictPlugin"
export default class extends Controller {
  static targets = ["list","user"]

  connect() {
    console.log("Hello from our first Stimulus controller")
    let firstUser
    if (document.querySelector(".carousel-item")){
      firstUser = document.querySelector(".carousel-item")
      firstUser.classList.add("active")
    }
    else {
      const emptyUser = document.querySelector(".empty-user")
      emptyUser.classList.toggle('d-none')
      const buttons = document.querySelector(".match-buttons")
      buttons.classList.add("d-none")
    }
  }


  swipeLeft(event){
    // recupérer l'user active
    // const card = event.currentTarget.closest(".user-card")
    // card.remove()
    if(document.querySelector(".carousel-item.active")){
      const activeUser = document.querySelector(".carousel-item.active")
      activeUser.classList.remove("active")
    }

    // s'il existe, récupérer l'user suivant
    if(document.querySelector(".carousel-item.active") && document.querySelector(".carousel-item.active").nextElementSibling){
      const nextUser = activeUser.nextElementSibling
      nextUser.classList.add("active")
    } else {
      const emptyUser = document.querySelector(".empty-user")
      emptyUser.classList.toggle('d-none')
    }
    // sinon générer un message
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
