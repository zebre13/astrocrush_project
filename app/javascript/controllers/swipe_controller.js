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
        e.target.classList.remove('profile-back');
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
            e.target.classList.add('profile-match');
          } else if (posX < -thresholdMatch){
            e.target.classList.add('profile-next');
          } else {
            e.target.classList.add('profile-back');
          }
        }
      })

    });
  }
}
