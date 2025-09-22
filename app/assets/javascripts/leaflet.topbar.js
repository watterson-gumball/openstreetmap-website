L.OSM.topbar = function (selector) {
  const control = {},
        topbar = $(selector).draggable();
  let current = $(),
      currentButton = $(),
      map;

  control.addTo = function (_) {
    map = _;
    return control;
  };

  control.state = new Map();

  control.addPane = function (pane) {
    pane
      .hide()
      .appendTo(topbar);

    control.state.set(pane, "hidden");
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
      control.state.set(pane, "hidden");
      $(topbar).hide();
      $("#content").addClass("overlay-right-topbar");
      current = currentButton = $();
      if (isMediumDevice) {
        map.panBy([0, -$("#map").height() / 2], { animate: false });
      } else if ($("html").attr("dir") === "rtl") {
        map.panBy([-paneWidth, 0], { animate: false });
      }
    } else {
      control.state.set(pane, "show");
      $(topbar).show();
      $("#content").removeClass("overlay-right-topbar");
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

  topbar.find(".topbar-close-controls button").on("click", () => {
    control.togglePane(current, currentButton);
  });

  return control;
};
