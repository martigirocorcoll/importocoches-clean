// app/javascript/controllers/youtube_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // 1) Declara que vas a usar un “idValue”
  static values = { id: String }

  connect() {
    // 2) Pon cursor pointer para que el usuario vea que es clicable
    this.element.style.cursor = "pointer"

    // 3) Al hacer click solo una vez...
    this.element.addEventListener("click", () => this.loadVideo(), { once: true })
  }

  loadVideo() {
    // 4) Lee this.idValue en vez de dataset.id
    const id = this.idValue

    // 5) Inyecta el iframe
    const iframe = document.createElement("iframe")
    iframe.src = `https://www.youtube.com/embed/${id}?autoplay=1`
    iframe.loading = "lazy"
    iframe.width = "100%"
    iframe.height = "100%"
    iframe.frameBorder = "0"
    iframe.allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    iframe.allowFullscreen = true

    this.element.innerHTML = ""
    this.element.appendChild(iframe)
  }
}
