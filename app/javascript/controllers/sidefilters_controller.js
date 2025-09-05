import { Controller } from "stimulus"
export default class extends Controller {
  connect() {
    let select0 = document.getElementById('models_dropdown')
    select0.options[1].remove();
    select0.options[1].remove();
  }

  initialize() {
    this.loadModel();
  }

  model(event) {
    console.log("event initialized");
    const marca = event.currentTarget.selectedOptions[0].innerText
    let select = document.getElementById('models_dropdown')
    while (select.options.length) select.remove(0)
    select.appendChild(new Option("", ""))
    $.parseJSON(select.dataset.model)[marca].forEach(element => {
      select.appendChild(new Option(element, element))
    });
    document.getElementById("btn_dis").disabled = false;
    document.getElementById("btn_dis_2").disabled = false;
  }

  loadModel(){
    const make = this.element.dataset.make;
    let select1 = document.getElementById('models_dropdown')
    const modelo = this.element.dataset.modelo;
    console.log("Buscando marca");
    console.log(make);
    console.log(select1);
    $.parseJSON(select1.dataset.model)[make].forEach(element => {
      select1.appendChild(new Option(element, element))
    });
    select1.value = modelo;
  }

}
