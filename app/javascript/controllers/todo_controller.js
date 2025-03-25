import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "list"]

  connect() {
    this.element.setAttribute("data-action", "keydown->todo#handleKeydown")
  }

  handleKeydown(event) {
    if (event.key === "Enter" && event.target.matches("[data-todo-edit]")) {
      event.target.blur()
    }
  }
}
