import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "expandIcon"]

  toggle() {
    this.contentTarget.classList.toggle("hidden")
    this.expandIconTarget.textContent = this.contentTarget.classList.contains("hidden") ? "▼" : "▲"
  }
}
