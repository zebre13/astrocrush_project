import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["field", "country","city", "utcoffset", "latitude", "longitude"]
  connect() {
    if(typeof(google) != undefined){
      this.initMap()
    }
  }

  initMap(){
    var options = { types: ['(cities)']}
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget, options)
    this.autocomplete.setFields(['address_components', 'geometry', 'name', 'utc_offset_minutes'])
    this.autocomplete.addListener('place_changed', this.placeChanged.bind(this))
  }

  placeChanged(){
    let place = this.autocomplete.getPlace()
    this.latitudeTarget.value = place.geometry.location.lat()
    this.longitudeTarget.value = place.geometry.location.lng()
    this.countryTarget.value = place.address_components[3].short_name
    this.cityTarget.value = place.address_components[0].long_name
    this.utcoffsetTarget.value = place.utc_offset_minutes
  }

}
