import { Controller } from "@hotwired/stimulus"
import UseStrictPlugin from "webpack/lib/UseStrictPlugin"
export default class extends Controller {
  static targets = ["list","user", "users", "emptyUser", "buttons"]

  connect() {
    // console.log("Hello from our first Stimulus controller")
    // console.log('This user target', this.userTarget)
    // console.log(' userTargets[0] ', this.userTargets[0])

    const mates = this.userTargets
    console.log( this.userTargets.length)
    // A la connexion à la page, verifier qu'il y ai bien un utilisateur
  }


  swipeLeft(event){
    const mates = this.userTargets
    event.preventDefault()
  //   // recupérer l'user active
    const card = event.currentTarget.closest(".user-card")

    // Il faut que j'enregistre en DB un match avec le status denied
    const url = "/create_denied_match"
    // console.log(url)
    const mateId = parseInt(this.userTargets[0].dataset.mateId, 10)
    // console.log(mateId)

    fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({"id": mateId})
    })
    console.log("fetched ok, now removing")
    card.remove()
    console.log(mates.length)
    if(mates.length === 1){
      window.location.reload(false);
    }
  }

  swipeRight(event){
    const mates = this.userTargets
    console.log("swipped right in process")
    event.preventDefault()
    const card = event.currentTarget.closest(".user-card")
    const url= "/matches"
    const mateId = parseInt(this.userTargets[0].dataset.mateId, 10)
    fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({"id": mateId})
    })
      .then(() => {
        if(mates.length === 1){
        window.location.reload(false);
      }})
      console.log("fetched ok, now removing : ici je dois rafraichir encore pour que la page disparaisse")
      card.remove()
    }


  }

  // swipe(event){
  //   const card = event.currentTarget.closest(".user-card")
  //   // Il faut que j'enregistre en DB un match avec le status denied
  //   const mateId = parseInt(this.userTargets[0].dataset.mateId, 10)
  //   let url
  //   if(event.direction = right) {
  //     url = "/matches"
  //     fetch(url, {
  //       method: "POST",
  //       headers: { "Content-Type": "application/json" },
  //       body: JSON.stringify({"id": mateId})
  //     })
  //     card.remove()
  //   }
  //   else if(event.direction = left){
  //     url = "/create_denied_matches"
  //     fetch(url, {
  //       method: "POST",
  //       headers: { "Content-Type": "application/json" },
  //       body: JSON.stringify({"id": mateId})
  //     })
  //     card.remove()
  //   }
  //   else {
  //     // ne rien faire si c'est en bas ou en haut
  //   }
  // }
