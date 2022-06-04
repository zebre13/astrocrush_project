import { Controller } from "@hotwired/stimulus"
import "swipe-listener"
export default class extends Controller {
  static targets = ["list","user"]

  connect() {
    console.log("Hello from our first Stimulus controller")
    const topUser = document.querySelector(".carousel-item")
    this.toggleActiveClass(topUser)
  }

  toggleActiveClass(element) {
    // Donner la classe active a l'element suivant
    element.classList.toggle("active")
  }

  swipeLeft(event){

  }

  swipeRight(event){

  }

}
// Aucune classe n'est active. Au chargement de la page, mettre la classe active à la premiere image.
// Quand swipe, mettre la classe active sur l'image suivante.
