import { createOptions } from "./createOptions.js";

const optionsWrapper = document.getElementById("options-wrapper");
const body = document.body;
const eye = document.getElementById("eyeSvg");
const hex = document.getElementById("hexSvg");
const alttakim = document.getElementById("alttakim");
alttakim.style.opacity = "0.0";

window.addEventListener("message", (event) => {
  optionsWrapper.innerHTML = "";

  switch (event.data.event) {
    case "visible": {
      body.style.visibility = event.data.state ? "visible" : "hidden";
      eye.classList.remove("eye-hover");
      hex.classList.remove("hex-hover");
      alttakim.style.transition = "none"; // Geen overgang
      alttakim.style.top = "53.1vh"; 
      alttakim.style.opacity = "0.0";
      break;
    }
    
    case "leftTarget": {
      eye.classList.remove("eye-hover");
      hex.classList.remove("hex-hover");
      alttakim.style.transition = "top 1.0s, opacity 1.0s"; // Langzamere overgang voor top en opacity
      alttakim.style.top = "53.1vh"; 
      alttakim.style.opacity = "0.0";
      break;
    }

    case "setTarget": {
      eye.classList.add("eye-hover");
      hex.classList.add("hex-hover");
      alttakim.style.transition = "top 1.0s, opacity 0.0s"; // Langzamere overgang voor top en opacity
      alttakim.style.top = "53.4vh"; 
      alttakim.style.opacity = "0.6";
      if (event.data.options) {
        for (const type in event.data.options) {
          event.data.options[type].forEach((data, id) => {
            createOptions(type, data, id + 1);
          });
        }
      }

      if (event.data.zones) {
        for (let i = 0; i < event.data.zones.length; i++) {
          event.data.zones[i].forEach((data, id) => {
            createOptions("zones", data, id + 1, i + 1);
          });
        }
      }
      break;
    }
  }
});