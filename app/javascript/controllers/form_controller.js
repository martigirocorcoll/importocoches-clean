import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  load() {
    // Solo una vez
    if (this.containerTarget.dataset.loaded === "true") return

    const iframe = document.createElement("iframe")
    iframe.src = "https://apps.clientify.net/forms/simpleembed/#/forms/embedform/235312/106957"
    iframe.loading = "lazy"
    iframe.width = "100%"
    iframe.height = "400"        // ajusta altura según tu diseño
    iframe.style.border = "none"
    iframe.title = "Formulario Clientify"

    this.containerTarget.appendChild(iframe)
    this.containerTarget.dataset.loaded = "true"
  }
}
