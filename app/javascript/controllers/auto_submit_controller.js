import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // No need for connect handler anymore as we're using action binding
  }

  submit() {
    this.element.closest("form").requestSubmit()
  }
}