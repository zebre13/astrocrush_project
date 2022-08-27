// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"





import Swal from 'sweetalert2';
import { Modal } from "bootstrap";

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "controllers"
import "bootstrap"

window.initMap = function(...args){
  // This is gonna create a event to broadcast at our stimulus controllers that need google map
  const event = document.createEvent("Events")
  event.initEvent("google-maps-callback", true, true)
  event.args = args
  window.dispatchEvent(event )
}
document.addEventListener('turbolinks:load', () => {
  const list = document.querySelectorAll('.list');
  function activeLink(){
    list.forEach((item)=>
    item.classList.remove('active'));
    this.classList.add('active');
  }
  list.forEach((item) =>
  item.addEventListener('click',activeLink));
})
