import { Controller } from "@hotwired/stimulus"
import Hammer from 'hammerjs';
import UseStrictPlugin from "webpack/lib/UseStrictPlugin"
export default class extends Controller {
  static targets = ["card","user", "users", "emptyUser", "buttons", "swipeLeftBtn", "swipeRightBtn"]

  connect() {
    console.log("coucou")
    console.log(this.userTargets.length)
    this._setupDragAndDrop();
  }

  _setupDragAndDrop() {
    this.userTargets.forEach((profile) => {
      const hammertime = new Hammer(profile);

      hammertime.on('pan', (e) => {
        let posX = e.deltaX;
        let posY = e.deltaY;

        const rotate = e.deltaX * 0.03 * e.deltaY / 80;
        e.target.style.transform = `translate(${e.deltaX}px, ${e.deltaY}px) rotate(${rotate}deg)`;

        if (e.isFinal) {

          e.target.style.transform = ``;
        }
      })

    });
  }
}
