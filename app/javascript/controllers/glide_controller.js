import { Controller } from "@hotwired/stimulus"
// import Glide, { Controls, Breakpoints } from '@glidejs/glide/dist/glide.modular.esm'
import Glide, { Controls, Breakpoints, Swipe } from '@glidejs/glide/dist/glide.modular.esm'



export default class extends Controller {

  connect() {
    new Glide('.glide', {
      type: 'carousel',
      startAt: 0,
      draggable: true,
      focusAt: 1,
      perView: 3,
      gap: 10,
      dragThreshold: 120,
      swipeThreshold: 140,
    } ).mount({ Controls, Breakpoints, Swipe})

    // var glide = new Glide('.glide', {
    //   type: 'carousel',
    //   perView: 3,
    //   gap: 5,
    //   touchRatio: 1,
    //   swipeThreshold: 30
    // })

    glide.mount({ Controls, Breakpoints, Swipe })

  }
}
