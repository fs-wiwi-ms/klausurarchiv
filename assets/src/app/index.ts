declare global {
  interface Window { liveSocket: any; }
}

import "@fortawesome/fontawesome-free/js/all.js";
import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken } })

// Connect if there are any LiveViews on the page
liveSocket.connect()

// Expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
// The latency simulator is enabled for the duration of the browser session.
// Call disableLatencySim() to disable:
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

function initModals() {
  const modalButton = document.querySelector("#open-modal");
  if (modalButton != null) {
    modalButton.addEventListener("click", (e) => {
      e.preventDefault();
      const modal = document.querySelector(".modal");  // assuming you have only 1
      const html = document.querySelector("html");
      modal.classList.add("is-active");
      html.classList.add("is-clipped");

      modal.querySelector(".modal-background").addEventListener("click", (e) => {
        e.preventDefault();
        modal.classList.remove("is-active");
        html.classList.remove("is-clipped");
      });

      modal.querySelector("#close-modal").addEventListener("click", (e) => {
        e.preventDefault();
        modal.classList.remove("is-active");
        html.classList.remove("is-clipped");
      });
    });
  }
}

function initNavBarBurger() {
  // Get all "navbar-burger" elements
  const navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
  // Check if there are any navbar burgers
  if (navbarBurgers.length > 0) {
    // Add a click event on each of them
    navbarBurgers.forEach((el: any) => {
      el.addEventListener("click", () => {
        // Get the target from the "data-target" attribute
        const target = el.dataset.target;
        const $target = document.getElementById(target);

        // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
        el.classList.toggle("is-active");
        $target.classList.toggle("is-active");
      });
    });
  }
}

function initNotifications() {
  (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
      var $notification = $delete.parentNode;

      $delete.addEventListener('click', () => {
        $notification.parentNode.removeChild($notification);
      });
    });
}

function initFileInput() {
  const fileInput = document.querySelector('#file-input');
  if (fileInput != null) {
    fileInput.addEventListener('change', (e) => {
      const fileInput = e.target as HTMLInputElement;
      if (fileInput.files.length > 0) {
        const fileName = document.querySelector('.file-name');
        fileName.textContent = fileInput.files[0].name;
      }
    });
  }
}



function initComponents() {
  initNavBarBurger();
  initModals();
  initNotifications();
  initFileInput();
}

if (document.readyState !== "loading") {
  initComponents();
} else {
  document.addEventListener("DOMContentLoaded", initComponents);
}

// import "./snow.js";

// snowStorm.animationInterval = 50;
// snowStorm.followMouse = true;
// snowStorm.snowStick = false;
// snowStorm.flakesMax = 200;
// snowStorm.snowColor = '#eee';
// snowStorm.freezeOnBlur = true;
// snowStorm.snowStick = true;
// snowStorm.vMaxX = 2;
// snowStorm.vMaxY = 2;

// snowStorm.toggleSnow();

import "./theme.sass";
