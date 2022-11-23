
import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap";

export default class extends Controller {
  static targets = [
    "birthDate",
    "birthHour",
    "field",
    "latitude",
    "longitude",
    "gender",
    "scoreAlert",
    "modal",
    "modalbody",
    "closeModalBtn"
  ];
  static values = {
    currentBirthDate: String,
    currentBirthHour: String,
    currentLatitude: Number,
    currentLongitude: Number,
    currentGender: Number,
    currentTimezone: Number,
    userId: String,
    apiKey: String,
  };

  connect = () => {
    if(typeof(google) != undefined) { this.#initMap() }
  };

  matchPercentage = (event) => {
    event.preventDefault();

    var crushData = {
      'day': parseInt(this.birthDateTarget.value.split('-')[2]),
      'month': parseInt(this.birthDateTarget.value.split('-')[1]),
      'year': parseInt(this.birthDateTarget.value.split('-')[0]),
      'hour': parseInt(this.birthHourTarget.value.split(':')[0]),
      'min': parseInt(this.birthHourTarget.value.split(':')[1]),
      'lat': parseFloat(this.latitudeTarget.value),
      'lon': parseFloat(this.longitudeTarget.value),
      'tzone': null
    };
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

    this.#setTimeZone(crushData)
    .then(resp => this.setGender(resp, currentData))
    .then(resp => this.#getMatchPercentage(resp))
    .catch(err => this.#failureCallback(err))
  };

  #setTimeZone = (crushData) => {
    const resource = 'timezone_with_dst';
    const data = {
      'latitude': crushData['lat'],
      'longitude': crushData['lon'],
      'date': `${crushData['month']}-${crushData['day']}-${crushData['year']}`,
    };

    return new Promise((resolve, reject) => {
      this.#request(resource, data).then((resp) => {
        crushData['tzone'] = parseFloat(resp['timezone']);
        resolve(crushData);
      }, (err) => {
        reject(err);
      });
    });
  };

  setGender = (crushData, currentData) => {
    const mData = {};
    const fData = {};

    return new Promise((resolve, reject ) => {
      if(this.currentGenderValue === 1){
        Object.entries(currentData).forEach(([k, v]) => {
          const el = {[`m_${k}`]: v};
          Object.assign(mData, el);
        });
        Object.entries(crushData).forEach(([k, v]) => {
          const el = {[`f_${k}`]: v};
          Object.assign(fData, el);
        });
      } else {
        Object.entries(crushData).forEach(([k, v]) => {
          const el = {[`m_${k}`]: v};
          Object.assign(mData, el);
        });
        Object.entries(currentData).forEach(([k, v]) => {
          const el = {[`f_${k}`]: v};
          Object.assign(fData, el);
        });
      }
      resolve({ ...mData, ...fData }), (err) => {
        reject(err);
      };
    });
  };

  #getMatchPercentage = (data) => {
    const resource = 'match_percentage';

    this.#request(resource, data).then((resp) => {
      var modal = new Modal(this.modalTarget);

      this.modalbodyTarget.innerHTML = `${resp.match_percentage} %`;
      modal.show();

      this.closeModalBtnTarget.addEventListener('click', (e) => {
        modal.hide();
        document.getElementById('myform').reset();
      });
      this.startConversationBtnTarget.addEventListener('click', (e) => {
        modal.hide();
      });
    }, (err) => {
      console.log(err);
    })
  };

  #failureCallback = (err) => console.log(err);

  #request = (resource, data) => {
    const userId = this.userIdValue;
    const apiKey = this.apiKeyValue;

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
  };

  #initMap = () => {
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget);
    this.autocomplete.setFields(['address_components', 'geometry', 'name', 'utc_offset_minutes']);
    this.autocomplete.addListener('place_changed', this.#placeChanged.bind(this));
  };

  #placeChanged = () => {
    let place = this.autocomplete.getPlace();
    this.latitudeTarget.value = place.geometry.location.lat();
    this.longitudeTarget.value = place.geometry.location.lng();
  };
};
