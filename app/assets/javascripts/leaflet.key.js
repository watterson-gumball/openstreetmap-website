L.OSM.key = function (options) {
  const control = L.OSM.sidebarPane(options, "key", null, "javascripts.key.title");

  control.onAddPane = function (map, button, $ui) {
    const $section = $("<div>")
      .attr("class", "p-3")
      .appendTo($ui);

    $ui
      .on("show", shown)
      .on("hide", hidden);

    map.on("baselayeradd", updateButton);

    updateButton();

    function shown() {
      map.on("zoomend baselayeradd", update);
      fetch("/key")
        .then(r => r.text())
        .then(html => { $section.html(html); })
        .then(update);
    }

    function hidden() {
      map.off("zoomend baselayeradd", update);
    }

    function updateButton() {
      const disabled = !map.getMapBaseLayer()?.options.hasLegend;
      button
        .toggleClass("disabled", disabled)
        .attr("data-bs-original-title",
              OSM.i18n.t(disabled ?
                "javascripts.key.tooltip_disabled" :
                "javascripts.key.tooltip"));
    }

    function update() {
      const layerId = map.getMapBaseLayerId(),
            zoom = map.getZoom();

      $("#mapkey [data-layer]").each(function () {
        const data = $(this).data();
        $(this).toggle(
          layerId === data.layer &&
          (!data.zoomMin || zoom >= data.zoomMin) &&
          (!data.zoomMax || zoom <= data.zoomMax)
        );
      });
    }
  };

  return control;
};
