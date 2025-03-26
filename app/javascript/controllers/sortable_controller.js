import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["list"]

  connect() {
    console.log("sortable connected")
    this.sortable = Sortable.create(this.listTarget, {
      animation: 150,
      onEnd: this.onDragEnd.bind(this)
    })
  }

  async onDragEnd(event) {
    const id = event.item.dataset.id
    const newPosition = event.newIndex

    try {
      const response = await fetch(`/todos/${id}/reorder`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ position: newPosition })
      })

      if (!response.ok) {
        throw new Error("Reordering failed")
      }
    } catch (error) {
      console.error("Error reordering todo:", error)
      // Revert the drag if there was an error
      event.item.parentNode.insertBefore(event.item, event.oldIndex < event.newIndex ? event.item.nextSibling : event.item.parentNode.children[event.oldIndex])
    }
  }
}
