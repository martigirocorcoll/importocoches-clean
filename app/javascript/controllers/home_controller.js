import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "text", "button_2", "text_2"]
  connect() {
  }

  change() {
    if (this.buttonTarget.innerText === "Leer más") {
      this.buttonTarget.innerText = "Leer menos"
      this.textTarget.classList.remove("d-none")
    } else {
      this.buttonTarget.innerText = "Leer más"
      this.textTarget.classList.add("d-none")
    }
  }

  change_2() {
    if (this.button_2Target.innerText === "Leer más") {
      this.button_2Target.innerText = "Leer menos"
      this.text_2Target.classList.remove("d-none")
    } else {
      this.button_2Target.innerText = "Leer más"
      this.text_2Target.classList.add("d-none")
    }
  }
}
