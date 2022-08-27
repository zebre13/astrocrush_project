import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["field"]
  connect() {
    console.log("places")
    if(typeof(google) != undefined){
      this.initMap()
    }
  }

  initMap(){
    console.log(google)
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget)
    this.autocomplete.setFields(['cities', 'countries', 'geometry'])
    this.autocomplete.addListener('place_changed', this.placeChanged.bind(this ))
  }

  placeChanged(){
    let place = this.autocomplete.getPlace()
    if(!place.geometry){
      window.alert('No details available for this input')
      return
    }
    this.latitudeTarget.value = place.geometry.location.lat()
    this.longitudeTarget.value = place.geometry.location.lng()

  }
}
