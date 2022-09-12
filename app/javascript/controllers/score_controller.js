import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["birthDate", "birthHour", "field", "latitude", "longitude", "gender", "scoreAlert"]
  static values = {
    currentBirthDate: String,
    currentBirthHour: String,
    currentLatitude: String,
    currentLongitude: String,
    currentGender: String
  }

  connect() {
    console.log("Hello from our Score controller")
    console.log(google)
    if(typeof(google) != undefined){
      this.initMap()
    }
  }

  match_percentage(event){
    event.preventDefault()

    // récupère les données du crush
    const crushData = {
      'day': parseInt(this.birthDateTarget.value.split('-')[2]),
      'month': parseInt(this.birthDateTarget.value.split('-')[1]),
      'year': parseInt(this.birthDateTarget.value.split('-')[0]),
      'hour': parseInt(this.birthHourTarget.value.split(':')[0]),
      'min': parseInt(this.birthHourTarget.value.split(':')[1]),
      'lat': parseFloat(this.latitudeTarget.value),
      'lon': parseFloat(this.longitudeTarget.value),
      'tzone': 5.5
    };

    // récupère les données du current user
    const currentData = {
      'day': parseInt(this.currentBirthDateValue.split('-')[2]),
      'month': parseInt(this.currentBirthDateValue.split('-')[1]),
      'year': parseInt(this.currentBirthDateValue.split('-')[0]),
      'hour': parseInt(this.currentBirthHourValue.split(' ')[1].split(':')[0]),
      'min': parseInt(this.currentBirthHourValue.split(' ')[1].split(':')[1]),
      'lat': parseFloat(this.currentLatitudeValue),
      'lon': parseFloat(this.currentLongitudeValue),
      'tzone': 5.5
    };

    // transforme les clés du current user et du crush en male ou female en fonction du sexe du current user

    var mData = {}
    var fData = {}
    if(this.currentGenderValue === 1){
      Object.entries(currentData).forEach(([k, v]) => {
        const el = {[`m_${k}`]: v};
        Object.assign(mData, el)
      });
      Object.entries(crushData).forEach(([k, v]) => {
        const el = {[`f_${k}`]: v};
        Object.assign(fData, el)
      });
    } else {
      Object.entries(crushData).forEach(([k, v]) => {
        const el = {[`m_${k}`]: v};
        Object.assign(mData, el)
      });
      Object.entries(currentData).forEach(([k, v]) => {
        const el = {[`f_${k}`]: v};
        Object.assign(fData, el)
      });
    }


    // appelle l'api

    var resource = 'match_percentage';
    var userId = '';
    var apiKey = '';

    var request = $.ajax({
      url: "https://json.astrologyapi.com/v1/"+resource,
      method: "POST",
      dataType:'json',
      headers: {
      "authorization": "Basic " + btoa(userId+":"+apiKey),
      "Content-Type":'application/json'
      },
      data:JSON.stringify({...mData, ...fData})
    });

    const response ={}
    request.then((resp) => {
      console.log(resp)
      // Object.entries(response, resp);
      this.scoreAlertTarget.classList.remove("d-none");
      this.scoreAlertTarget.innerText = `<div id = "matchAlert"> ${resp.match_percentage} % </div>`
    }, (err) => {
      console.log(err);
    });
  };


  // google map

  initMap(){
    console.log(google)
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget)
    this.autocomplete.setFields(['address_components', 'geometry', 'name', 'utc_offset_minutes'])
    this.autocomplete.addListener('place_changed', this.placeChanged.bind(this))
    console.log(this.autocomplete)
  };

  placeChanged(){
    let place = this.autocomplete.getPlace()
    this.latitudeTarget.value = place.geometry.location.lat()
    this.longitudeTarget.value = place.geometry.location.lng()
  };

}
