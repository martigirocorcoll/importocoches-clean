import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  connect() {
    let select = document.getElementById('models_dropdown')
    select.options[1].remove();
    select.options[1].remove();
    const make = this.element.dataset.make;
    const modelo = this.element.dataset.modelo;
    console.log("Sin buscar marca");
  }
  model(event) {
    console.log("event initialized");
    const marca = event.currentTarget.selectedOptions[0].innerText
    let select = document.getElementById('models_dropdown')
    while (select.options.length) select.remove(0)
    select.appendChild(new Option("", ""))
    JSON.parse(select.dataset.model)[marca].forEach(element => {
      select.appendChild(new Option(element, element))
    });
    document.getElementById("btn_dis").disabled = false;
    document.getElementById("btn_dis_2").disabled = false;
  }
}
