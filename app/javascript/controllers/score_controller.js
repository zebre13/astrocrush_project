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
    console.log(event)

    // if (currentUser.gender == 1) {
      // const m_birth_day = currentUser.birth_day
      // const m_birth_hour = currentUser.birth_hour
      // const m_birth_location = currentUser.birth_location
      // const m_birth_country = currentUser.birth_country
      // const f_birth_day = this.birth_dayTarget.value
      // const f_birth_hour = this.birth_hourTarget.value
      // const f_birth_location = this.latitudeTarget.value
      // const f_birth_country = this.longitudeTarget.value
    // }
  //   console.log(birthday)
  //   console.log(birth_hour)
  //   console.log(birth_location)
  //   console.log(birth_country)
    console.log(this.birth_dayTarget.value)
    console.log(this.birth_hourTarget.value)
    console.log(this.latitudeTarget.value)
    console.log(this.longitudeTarget.value)
    console.log(this.genderTarget.value)

    // je veux un nouvel user avec les données + haut
    // je veux comparer le pourcentage match entre mon current user et ce user


    // const url = this.birthday.action
    // fetch(url, options)
    // .then(response => response.json())
    // .then(data => {
    //   console.log(data)
    // })

    // var input_code = (birthday, birth_hour, birth_location, birth_country, current_user.birth_date, current_user.birth_hour, current_user.birth_location, current_user.birth_country);
    // this.getJSON('match_percentage/'+input_code+'/<%= @code %>').done(function(data){
    //   alert(data);
    // })
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
    // this.countryTarget.value = place.address_components[3].short_name
    // this.cityTarget.value = place.address_components[0].long_name
    // this.utcoffsetTarget.value = place.utc_offset_minutes
  }
}
