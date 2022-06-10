let marker;
let lat;
let lng;

function initMap() {
  const location = { lat: 36.71301262566997, lng: 137.87261375590265 };
  const mapSetting = { targetId: "map-location-registration", zoom: 13 };
  
  if (document.getElementById("map-location-registration")) {
    const model = document.getElementById("map-section").dataset.model
    const action = document.getElementById("map-section").dataset.action
    lat = document.getElementById(`${model}_${action}_form_${model}_attributes_lat`).value;
    lng = document.getElementById(`${model}_${action}_form_${model}_attributes_lng`).value;

    if (lat && lng) {
      location.lat = convertIntoFloat(lat);
      location.lng = convertIntoFloat(lng);
    }
  } else if (document.getElementById("map-location-display")) {
    const mapLocation = document.getElementById("map-location-display");
    location.lat = convertIntoFloat(mapLocation.dataset.lat);
    location.lng = convertIntoFloat(mapLocation.dataset.lng);
    mapSetting.targetId = "map-location-display";
    mapSetting.zoom = 16;
  }

  const map = new google.maps.Map(
    document.getElementById(mapSetting.targetId),
    {
      zoom: mapSetting.zoom,
      center: { lat: location.lat, lng: location.lng },
      mapTypeControl: false,
      streetViewControl: false,
      rotateControl: true,
      fullscreenControl: true,
    }
  );

  if (
    document.getElementById("map-location-display") ||
    (document.getElementById("map-location-registration") && lat && lng)
  ) {
    marker = new google.maps.Marker({
      map: map,
      position: location,
    });
  }

  if (document.getElementById("map-location-registration")) {
    map.addListener("click", (e) => {
      getPosition(e.latLng, map);
    });
  }

  // -------------- not to display information popup -------------- //
    
  (function fixInfoWindow() {
    var set = google.maps.InfoWindow.prototype.set;
    google.maps.InfoWindow.prototype.set = function(key, val) {
      if (key === "map") {
        if (! this.get("noSuppress")) {
          return;
        }
      }
      set.apply(this, arguments);
    }
  })();
}

function getPosition(lat_lng, map) {
  const model = document.getElementById("map-section").dataset.model
  const action = document.getElementById("map-section").dataset.action
  document.getElementById(`${model}_${action}_form_${model}_attributes_lat`).value = lat_lng.lat();
  document.getElementById(`${model}_${action}_form_${model}_attributes_lng`).value = lat_lng.lng();

  map.panTo(lat_lng);

  if (marker) {
    marker.setMap(null);
    marker = null;
  }
  marker = new google.maps.Marker({
    map: map,
    position: lat_lng,
  });
}

function convertIntoFloat(string) {
  return parseFloat(string);
}
