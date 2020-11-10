import "@fortawesome/fontawesome-free/js/all.js";
// import Tagify from '@yaireo/tagify'

// import flatpickr from "flatpickr";
// import { German } from "flatpickr/dist/l10n/de.js";
// import "flatpickr/dist/themes/dark.css";
// import BulmaTagsInput from '@creativebulma/bulma-tagsinput';

// const FLATPICKR_DATETIME_CONFIG = {
//   altInput: true,
//   altFormat: "j. F Y H:i",
//   enableTime: true,
//   dateFormat: "Z",
//   time_24hr: true,
//   locale: German,
//   placeholder: "Datum auswählen",
//   minDate: new Date(),
// };

// const FLATPICKR_DATE_CONFIG = {
//   altInput: true,
//   altFormat: "j. F Y",
//   enableTime: false,
//   dateFormat: "Y-m-d",
//   locale: German,
//   placeholder: "Datum auswählen",
// };

// function initDatePickers() {
//   flatpickr(
//     document.querySelectorAll(".datetimepicker"),
//     FLATPICKR_DATETIME_CONFIG,
//   );
//   flatpickr(
//     document.querySelectorAll(".datepicker"),
//     FLATPICKR_DATE_CONFIG,
//   );
// }

// function initCheckBoxHideShow() {
//   const checkBox = document.querySelector("#checkBoxClick");
//   if (checkBox != null) {
//     checkBox.addEventListener("click", (e) => {
//       const checkBox = document.getElementById("checkBoxElem") as HTMLInputElement;
//       const content = document.getElementById("checkBoxContent");
//       // If the checkbox is checked, display the output text
//       if (checkBox.checked == true) {
//         content.style.display = "block";
//       } else {
//         content.style.display = "none";
//       }
//     });
//   }
// }

// function initModals() {
//   const modalButton = document.querySelector("#open-modal");
//   if (modalButton != null) {
//     modalButton.addEventListener("click", (e) => {
//       e.preventDefault();
//       const modal = document.querySelector(".modal");  // assuming you have only 1
//       const html = document.querySelector("html");
//       modal.classList.add("is-active");
//       html.classList.add("is-clipped");

//       modal.querySelector(".modal-background").addEventListener("click", (e) => {
//         e.preventDefault();
//         modal.classList.remove("is-active");
//         html.classList.remove("is-clipped");
//       });

//       modal.querySelector("#close-modal").addEventListener("click", (e) => {
//         e.preventDefault();
//         modal.classList.remove("is-active");
//         html.classList.remove("is-clipped");
//       });
//     });
//   }
// }

// function initNavBarBurger() {
//     // Get all "navbar-burger" elements
//   const navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
//   // Check if there are any navbar burgers
//   if (navbarBurgers.length > 0) {
//     // Add a click event on each of them
//     navbarBurgers.forEach((el: any) => {
//       el.addEventListener("click", () => {
//         // Get the target from the "data-target" attribute
//         const target = el.dataset.target;
//         const $target = document.getElementById(target);

//         // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
//         el.classList.toggle("is-active");
//         $target.classList.toggle("is-active");
//       });
//     });
//   }
// }

// function initFileInput() {
//   const fileInput = document.querySelector('#file-input');
//   if (fileInput != null) {
//     fileInput.addEventListener('change', (e) => {
//       const fileInput = e.target as HTMLInputElement;
//       if (fileInput.files.length > 0) {
//         const fileName = document.querySelector('.file-name');
//         fileName.textContent = fileInput.files[0].name;
//       }
//     });
//   }
// }

// function initInputTagger(){
//   const input = document.querySelector('#tag-input');
//   if (input != null) {
//     new Tagify(input);
//   }
// }

// function initComponents () {
//   initNavBarBurger();
//   initInputTagger();
//   initFileInput();
//   initDatePickers();
//   initCheckBoxHideShow();
//   initModals();
//   BulmaTagsInput.attach();
// }

// if (document.readyState !== "loading") {
//   initComponents();
// } else {
//   document.addEventListener("DOMContentLoaded", initComponents);
// }

import "./theme.sass";
