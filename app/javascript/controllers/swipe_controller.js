import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap";
import Hammer from 'hammerjs';
import UseStrictPlugin from "webpack/lib/UseStrictPlugin"
window.bootstrap = require('bootstrap/dist/js/bootstrap.bundle.js');
const Swal = require('sweetalert2')
export default class extends Controller {
  static targets = ["user", "modal", "modalbody", "closeModalBtn", "startConversationBtn"]

  connect() {
    // console.log("coucou")
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
        e.target.classList.remove('profile-back');
        let posX = e.deltaX;
        let posY = Math.max(0, Math.abs(posX * smooth) - 42);
        let angle = Math.min(Math.abs(e.deltaX * smooth / 100), 1) * maxAngle;

        if(e.deltaX < 0) {
          angle *= -1;
        }

        e.target.style.transform = `translate(${posX}px, ${posY}px) rotate(${angle}deg)`;
        profile.classList.remove('profile-matching');
        profile.classList.remove('profile-nexting');

        if(posX > thresholdMatch){
          e.target.classList.remove('profile-nexting');
          e.target.classList.add('profile-matching')
        } else if (posX < -thresholdMatch){
          e.target.classList.remove('profile-matching')
          e.target.classList.add('profile-nexting')
        }

        if (e.isFinal) {
          e.target.style.transform = ``;
          if(posX > thresholdMatch){
            e.target.classList.add('profile-match')
            profile.remove()
            this.swipeRight(e)
          } else if (posX < -thresholdMatch){
            e.target.classList.add('profile-next')
            profile.remove()
            this.swipeLeft(e)
          } else {
            e.target.classList.add('profile-back');
            e.target.classList.remove('profile-nexting');
            e.target.classList.remove('profile-matching')
          }
        }
      })

    });
  }

  swipeLeft(event){

    const dataId = event.target.parentElement.dataset.id
    console.log(dataId)
    const mateId = parseInt(dataId, 10)
    const url = "/create_denied_match"
    fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({"id": mateId})
    })
  }

  swipeRight(event){
    const dataId = event.target.parentElement.dataset.id
    const mateId = parseInt(dataId, 10)
    const url= "/matches"
    fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({"id": mateId})
    })
    .then(response => response.json())
    .then(data => {
      console.log('hello ->', data)
      if(data.match.status === 'accepted'){
        // Swal.fire({
        //   title: "It's an AstroMatch!",
        //   text: 'Start conversation',

        //   confirmButtonText: 'keep swiping'
        // })
        console.log(this.modalTarget)
        var modal = new Modal(this.modalTarget)
        this.modalbodyTarget.innerHTML = data.content
        modal.show()
        this.closeModalBtnTarget.addEventListener('click', (e) => {
          modal.hide()
        });
        this.startConversationBtnTarget.addEventListener('click', (e) => {
              modal.hide()
            });
      }
    })
  }

}
