import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["birth_day", "birth_hour", "birth_location", "birth_country"]

  connect() {
    console.log("Hello from our Score controller")
  }

  match_percentage(event){
    event.preventDefault()
    console.log(event)

    // if (currentUser.gender == 1) {
      // const m_birth_day = currentUser.birth_day
      // const m_birth_hour = currentUser.birth_hour
      // const m_birth_location = currentUser.birth_location
      // const m_birth_country = currentUser.birth_country
      const f_birth_day = this.birth_dayTarget.value
      const f_birth_hour = this.birth_hourTarget.value
      const f_birth_location = this.birth_locationTarget.value
      const f_birth_country = this.birth_countryTarget.value
    // }
  //   console.log(birthday)
  //   console.log(birth_hour)
  //   console.log(birth_location)
  //   console.log(birth_country)
    console.log(this.birth_dayTarget.value)
    console.log(this.birth_hourTarget.value)
    console.log(this.birth_locationTarget.value)
    console.log(this.birth_countryTarget.value)

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
}
