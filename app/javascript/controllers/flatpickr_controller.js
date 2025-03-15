import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static targets = ["input", "toggle"]

  connect() {
    this.fp = flatpickr(this.inputTarget, {
      dateFormat: "Y-m-d",
      allowInput: true,
      altInput: true,
      altFormat: "F j, Y", // More human-readable format (e.g., "January 1, 2023")
      wrap: true,
      disableMobile: false,
      monthSelectorType: "static",
      appendTo: this.element
    })
    
    if (this.hasToggleTarget) {
      this.toggleTarget.addEventListener("click", () => {
        this.fp.toggle()
      })
    }
  }

  disconnect() {
    if (this.fp) {
      this.fp.destroy()
    }
  }
} 