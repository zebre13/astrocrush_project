import { Controller } from "@hotwired/stimulus"
import Hammer from 'hammerjs';
import UseStrictPlugin from "webpack/lib/UseStrictPlugin"
export default class extends Controller {
  static targets = ["user"]

  connect() {
    console.log("coucou")
    console.log(this.userTargets.length)
    this._setupDragAndDrop();
  }


  _setupDragAndDrop() {
    const maxAngle = 42;
    const smooth = 0.3;
    const threshold = 42;
    const thresholdMatch = 150;

    this.userTargets.forEach((profile) => {
      const hammertime = new Hammer(profile);

      hammertime.on('pan', (e) => {
        // e.target.classList.remove('profile-back');
        let posX = e.deltaX;
        let posY = Math.max(0, Math.abs(posX * smooth) - 42);
        let angle = Math.min(Math.abs(e.deltaX * smooth / 100), 1) * maxAngle;

        if(e.deltaX < 0) {
          angle *= -1;
        }

        e.target.style.transform = `translate(${posX}px, ${posY}px) rotate(${angle}deg)`;

        if (e.isFinal) {
          e.target.style.transform = ``;
          if(posX > thresholdMatch){
            profile.remove()
            this.swipeRight(e)
          } else if (posX < -thresholdMatch){
            profile.remove()
            this.swipeLeft(e)
          } else {
            // e.target.classList.add('profile-back');
          }
        }
      })

    });
  }

  swipeLeft(event){
    console.log(event.target.parentElement)
    // const mate = this.userTargets
    // event.preventDefault()
    // const card = event.currentTarget.closest(".user-card")

    // const url = "/create_denied_match"
    // const mateId = parseInt(this.userTargets[0].dataset.mateId, 10)

    // fetch(url, {
    //   method: "POST",
    //   headers: { "Content-Type": "application/json" },
    //   body: JSON.stringify({"id": mateId})
    // })
    // console.log("fetched ok, now removing")
    // card.remove()
    // console.log(mates.length)
    // if(mates.length === 1){
    //   window.location.reload(false);
    // }
  }

  swipeRight(event){
    console.log(event.target.parentElement)
    // const mates = this.userTargets
    // console.log("swipped right in process")
    // const card = event.currentTarget.closest(".user-card")
    // const url= "/matches"
    // const mateId = parseInt(this.userTargets[0].dataset.mateId, 10)
    // fetch(url, {
    //   method: "POST",
    //   headers: { "Content-Type": "application/json" },
    //   body: JSON.stringify({"id": mateId})
    // })
    //   .then(() => {
    //     if(mates.length === 1){
    //     window.location.reload(false);
    //   }})
    //   console.log("fetched ok, now removing : ici je dois rafraichir encore pour que la page disparaisse")
    //   card.remove()
    }
}
