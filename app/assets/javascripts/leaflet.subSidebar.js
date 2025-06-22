L.OSM.subSidebar = function (selector) {
  const control = {},
        subSidebar = $(selector);
  let current = $(),
      currentButton = $(),
      map;

  L.Util.extend(control, L.Evented.prototype);

  control.addTo = function (_) {
    map = _;
    return control;
  };

  control.addPane = function (pane) {
    pane
      .hide()
      .appendTo(subSidebar);
  };

  control.togglePane = function (pane, button) {
    const mediumDeviceWidth = window.getComputedStyle(document.documentElement).getPropertyValue("--bs-breakpoint-md");
    const isMediumDevice = window.matchMedia(`(max-width: ${mediumDeviceWidth})`).matches;
    const paneWidth = 250;

    current
      .hide()
      .trigger("hide");

    currentButton
      .parent()
      .removeClass("active");

    if (current === pane) {
      $(subSidebar).hide();
      current = currentButton = $();
      if (isMediumDevice) {
        map.panBy([0, -$("#map").height() / 2], { animate: false });
      } else if ($("html").attr("dir") === "rtl") {
        map.panBy([-paneWidth, 0], { animate: false });
      }
    } else {
      $(subSidebar).show();
      current = pane;
      currentButton = button || $();
      if (isMediumDevice) {
        map.panBy([0, $("#map").height()], { animate: false });
      } else if ($("html").attr("dir") === "rtl") {
        map.panBy([paneWidth, 0], { animate: false });
      }
    }

    map.invalidateSize({ pan: false, animate: false });

    current
      .show()
      .trigger("show");

    currentButton
      .parent()
      .addClass("active");
  };

  subSidebar.find(".sub-sidebar-close-controls button").on("click", () => {
    control.togglePane(current, currentButton);
  });

  subSidebar.draggable();

  return control;
};
