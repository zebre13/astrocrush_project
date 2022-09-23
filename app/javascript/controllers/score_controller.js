import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap";

export default class extends Controller {
  static targets = ["birthDate", "birthHour", "field", "latitude", "longitude", "gender", "scoreAlert", "modal", "modalbody", "closeModalBtn"]
  static values = {
    currentBirthDate: String,
    currentBirthHour: String,
    currentLatitude: Number,
    currentLongitude: Number,
    currentGender: Number,
    currentTimezone: Number,
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

    // function request pour l'appel d'API
    var request = (resource, data) => {
      const userId = '619845';
      const apiKey = '0fe9a97cde1e13cefe57c49cf2643167';

      return $.ajax({
        url: "https://json.astrologyapi.com/v1/"+resource,
        method: "POST",
        dataType:'json',
        headers: {
          "authorization": "Basic " + btoa(userId+":"+apiKey),
          "Content-Type":'application/json'
        },
        data:JSON.stringify(data)
      });
    }

    // récupère les données du current user
    var currentData = {
      'day': parseInt(this.currentBirthDateValue.split('-')[2]),
      'month': parseInt(this.currentBirthDateValue.split('-')[1]),
      'year': parseInt(this.currentBirthDateValue.split('-')[0]),
      'hour': parseInt(this.currentBirthHourValue.split(' ')[1].split(':')[0]),
      'min': parseInt(this.currentBirthHourValue.split(' ')[1].split(':')[1]),
      'lat': parseFloat(this.currentLatitudeValue),
      'lon': parseFloat(this.currentLongitudeValue),
      'tzone': parseFloat(this.currentTimezoneValue)
    };

    // récupère les données du crush
    var crushData = {
      'day': parseInt(this.birthDateTarget.value.split('-')[2]),
      'month': parseInt(this.birthDateTarget.value.split('-')[1]),
      'year': parseInt(this.birthDateTarget.value.split('-')[0]),
      'hour': parseInt(this.birthHourTarget.value.split(':')[0]),
      'min': parseInt(this.birthHourTarget.value.split(':')[1]),
      'lat': parseFloat(this.latitudeTarget.value),
      'lon': parseFloat(this.longitudeTarget.value),
      'tzone': 0.0
    };

    // function appel de l'api pour le timezone crush
    const setTimeZone = () => {
      const resource = 'timezone_with_dst';
      const data = {
        'latitude': crushData['lat'],
        'longitude': crushData['lon'],
        'date': `${crushData['month']}-${crushData['day']}-${crushData['year']}`,
      }

      return new Promise((resolve, reject) => {
        request(resource, data).then((resp) => {
          crushData['tzone'] = parseFloat(resp['timezone']);
          resolve(crushData)
        }, (err) => {
          reject(err);
        })
      });
    }

    // function transforme les clés du current user et du crush en male ou female en fonction du sexe du current user
    const setGender = (crushData) => {
      const mData = {}
      const fData = {}
      return new Promise((resolve) => {
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
$        }
        resolve({...mData, ...fData});
      })
    }

    // function appel de l'api pour le match_percentage
    const getMatchPercentage = (data) => {
      const resource = 'match_percentage';

      request(resource, data).then((resp) => {
        // console.log(resp);
        // this.scoreAlertTarget.classList.remove("d-none");
        // this.modalbodyTarget.innerText = `Your compatibility : ${resp.match_percentage} %`;

        var modal = new Modal(this.modalTarget)
        this.modalbodyTarget.innerHTML = `${resp.match_percentage} %`
        modal.show()
        this.closeModalBtnTarget.addEventListener('click', (e) => {
          modal.hide()
          document.getElementById('myform').reset();
        });
        this.startConversationBtnTarget.addEventListener('click', (e) => {
              modal.hide()
            });

        // alert(`Your compatibility : ${resp.match_percentage} %`)
      }, (err) => {
        console.log(err);
      })
    }

    // function echec
    const failureCallback = (err) => console.log(err)

    // setTimezone puis setGender puis getMatchPercentage
    setTimeZone()
    .then((resp) => setGender(resp))
    .then((resp) => getMatchPercentage(resp))
    .catch((err) => failureCallback(err))
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

};
