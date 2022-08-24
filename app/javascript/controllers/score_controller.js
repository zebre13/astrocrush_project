import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["birthday", "birth_hour", "birth_location", "birth_country"]
  connect() {
    console.log("Hello from our Test Score controller")
  }

  match_percentage(event){
    event.preventDefault()
    const birthday = this.birthdayTarget.value
    const birth_hour = this.birth_hourTarget.value
    const birth_location = this.birth_locationTarget.value
    const birth_country = this.birth_countryTarget.value

    console.log(birthday)
    console.log(birth_hour)
    console.log(birth_location)
    console.log(birth_country)

    var input_code = (birthday, birth_hour, birth_location, birth_country, current_user.birth_date, current_user.birth_hour, current_user.birth_location, current_user.birth_country);
    this.getJSON('match_percentage/'+input_code+'/<%= @code %>').done(function(data){
      alert(data);
    })
  };
}
