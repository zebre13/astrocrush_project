import { Controller } from "@hotwired/stimulus"
import Glide, { Controls, Breakpoints } from '@glidejs/glide/dist/glide.modular.esm'



export default class extends Controller {

  connect() {


    new Glide('.glide').mount({ Controls, Breakpoints })
  }
    }
