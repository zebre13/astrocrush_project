import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["field", "country"]
  connect() {
    console.log("places controller connect")
    if(typeof(google) != undefined){
      this.initMap()
    }
  }

  initMap(){
    console.log(google)
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget)
    this.autocomplete.setFields(['address_components', 'geometry', 'name', 'utc_offset_minutes'])
    this.autocomplete.addListener('place_changed', this.placeChanged.bind(this))
    console.log(this.autocomplete)
  }

  placeChanged(){
    let place = this.autocomplete.getPlace()
    // this.latitudeTarget.value = place.geometry.location.lat()
    // this.longitudeTarget.value = place.geometry.location.lng()
    console.log(place)
    console.log(place.utc_offset)
    console.log(place.address_components[3].short_name)
    this.countryTarget.value = place.address_components[3].short_name
  }

}
