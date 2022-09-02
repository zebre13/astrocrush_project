import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["birth_day", "birth_hour", "field", "latitude", "longitude", "gender"]

  connect() {
    console.log("Hello from our Score controller")
    console.log(google)
    if(typeof(google) != undefined){
      this.initMap()
    }
  }

  match_percentage(event){
    event.preventDefault()
    console.log(document.querySelector("#user-latitude").getAttribute("data-user-latitude"))
    console.log(document.querySelector("#user-longitude").getAttribute("data-user-longitude"))
    console.log(document.querySelector("#user-birth-hour").getAttribute("data-user-birth-hour"))
    console.log(document.querySelector("#user-birth-date").getAttribute("data-user-birth-date"))
    console.log(document.querySelector("#user-gender").getAttribute("data-user-gender"))

    console.log(this.birth_dayTarget.value)
    console.log(this.birth_hourTarget.value)
    console.log(this.latitudeTarget.value)
    console.log(this.longitudeTarget.value)
    console.log(this.genderTarget.value)

  };

  initMap(){
    console.log(google)
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget)
    this.autocomplete.setFields(['address_components', 'geometry', 'name', 'utc_offset_minutes'])
    this.autocomplete.addListener('place_changed', this.placeChanged.bind(this))
    console.log(this.autocomplete)
  }

  placeChanged(){
    let place = this.autocomplete.getPlace()
    this.latitudeTarget.value = place.geometry.location.lat()
    this.longitudeTarget.value = place.geometry.location.lng()
  }
}